//
// Created by Danil on 2019-05-22.
// Copyright (c) 2019 DeadMolesStudio. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let MONEY_SERVICE_KEY = "MONEY_SERVICE_KEY"
let MONEY_SERVICE_INCOMES_KEY = MONEY_SERVICE_KEY + "_INCOMES"
let MONEY_SERVICE_COSTS_KEY = MONEY_SERVICE_KEY + "_COSTS"

func ConvertArrays(from strs: [CategoryStr]) -> [Category] {
    var result = [Category]()
    for item in strs {
        result.append(Category(fromCategoryStr: item))
    }
    return result
}

func ConvertArraysToEntities(from strs: [CategoryStr], managedContext: NSManagedObjectContext) -> [NSManagedObject] {
    var result = [NSManagedObject]()
    for item in strs {
        result.append(Category.CategoryEntity(fromCategoryStr: item, managedContext: managedContext)!)
    }
    return result
}


fileprivate func getCategoriesFromCoreData(type: String) -> [Category]? {
    var isIncome = true
    if (type == MONEY_SERVICE_COSTS_KEY) {
        isIncome = false
    }
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let currentUsername = Auth.getCurrentUserEntity()?.value(forKey: "username") as? String ?? "ANON"
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryModel")
    let ownerPredicate = NSPredicate(format: "owner.username=%@", currentUsername)
    let typePredicate = NSPredicate(format: "isIncome=%@", NSNumber(value: isIncome))
    let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [typePredicate, ownerPredicate])
    
    fetchRequest.predicate = andPredicate
    
    var categories = [Category]()
    do {
        let result = try managedContext.fetch(fetchRequest)
        for data in result as! [NSManagedObject] {
            categories.append(Category(fromCategoryEntity: data))
        }
    } catch {
        print("Failed")
    }
    
    return categories
}

enum MoneyServiceError: Error {
    case NameExists
    case CategoryNotExists
}

class MoneyService {
    var costs: [Category]
    var incomes: [Category]

    private static var storage: MoneyService = {
        let ms = MoneyService()
        return ms
    }()

    class func GetService() -> MoneyService {
        return self.storage
    }

    private init() {
        self.incomes = getCategoriesFromCoreData(type: MONEY_SERVICE_INCOMES_KEY)!
        self.costs = getCategoriesFromCoreData(type: MONEY_SERVICE_COSTS_KEY)!
        
//        if let ms = defaults.data(forKey: MONEY_SERVICE_INCOMES_KEY) {
//            self.incomes = NSKeyedUnarchiver.unarchiveObject(with: ms) as! [Category]
//        } else {
//            self.incomes = ConvertArrays(from: incomeDefaultCategories)
//        }
//        if let ms = defaults.data(forKey: MONEY_SERVICE_COSTS_KEY) {
//            self.costs = NSKeyedUnarchiver.unarchiveObject(with: ms) as! [Category]
//        } else {
//            self.costs = ConvertArrays(from: costsDefaultCategories)
//        }
    }
    

//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(<#T##data: Data##Foundation.Data#>)
//    }

    func save() {
        let defaults = UserDefaults.standard
        let encodeDataCosts: Data = NSKeyedArchiver.archivedData(withRootObject: self.costs)
        let encodeDataIncomes: Data = NSKeyedArchiver.archivedData(withRootObject: self.incomes)
        defaults.set(encodeDataIncomes, forKey: MONEY_SERVICE_INCOMES_KEY)
        defaults.set(encodeDataCosts, forKey: MONEY_SERVICE_COSTS_KEY)
//        defaults.set(self, forKey: MONEY_SERVICE_KEY)

        // TODO: make request to API to save

    }

    func addIncomeCategory(with from: Category) throws {
        let exists = self.incomes.filter {
            $0.name == from.name
        }
        if exists.count == 0 {
            self.incomes.append(from)
        } else {
            throw MoneyServiceError.NameExists
        }
        self.save()
    }

    func addCostCategory(with from: Category) throws {
        let exists = self.costs.filter {
            $0.name == from.name
        }
        if exists.count == 0 {
            self.costs.append(from)
        } else {
            throw MoneyServiceError.NameExists
        }
        self.save()
    }

    func getCategory(by: Category, from: [Category]) -> Category? {
        var category: Category?
        var exists = from.filter {
            $0.name == by.name
        }
        if let elem = exists.popLast() {
            category = elem
        }
        exists = self.incomes.filter {
            $0.name == by.name
        }
        if let elem = exists.popLast() {
            category = elem
        }
        return category
    }

    func transfer(from: Category, to: Category, value: Int, photo: UIImage, id: UUID?) throws {
        let from_category_index: Int? = self.incomes.firstIndex {$0.name == from.name}
        let from_item:Category
        if let fci = from_category_index {
            from_item = self.incomes[fci]
        } else if let fci = self.costs.firstIndex(where: {$0.name == from.name}) {
            from_item = self.costs[fci]
        } else {
            throw MoneyServiceError.CategoryNotExists
        }
        let to_category_index: Int? = self.incomes.firstIndex {$0.name == to.name}
        let to_item:Category
        if let fci = to_category_index {
            to_item = self.incomes[fci]
        } else if let fci = self.costs.firstIndex(where: {$0.name == to.name}) {
            to_item = self.costs[fci]
        } else {
            throw MoneyServiceError.CategoryNotExists
        }
        from_item.value -= value
        to_item.value += value
        var op: Operation
        if id == nil {
           op = Operation(from: from_item, to: to_item, value: value, photo: photo)
        } else {
            print("CREATE OPERATIONS WITH ID WTFFFFFF")
            op = Operation(from: from_item, to: to_item, value: value, id: id!, photo: photo)
        }
        History.GetHistory().addOrUpdateOperation(operation: op)
    }

    func transfer(fromString: String, toString: String, value: Int, photo: UIImage, id: UUID!) throws {
        let from = Category()
        from.name = fromString
        let to = Category()
        to.name = toString
        try self.transfer(from: from, to: to, value: value, photo: photo, id: id)
    }

    func addMoney(to category: Category, amount money: Int) {
        category.value += money
        self.save()
    }
    
    func configureOperationByCategories(fromString: String, toString: String) -> Operation {
        let from_category_index: Int? = self.incomes.firstIndex {$0.name == fromString}
        var from_item:Category = Category()
        if let fci = from_category_index {
            from_item = self.incomes[fci]
        } else if let fci = self.costs.firstIndex(where: {$0.name == fromString}) {
            from_item = self.costs[fci]
        }
        let to_category_index: Int? = self.incomes.firstIndex {$0.name == toString}
        var to_item:Category = Category()
        if let fci = to_category_index {
            to_item = self.incomes[fci]
        } else if let fci = self.costs.firstIndex(where: {$0.name == toString}) {
            to_item = self.costs[fci]
        }
        let op = Operation(from: from_item, to: to_item, value: 0)
        return op
    }
}

