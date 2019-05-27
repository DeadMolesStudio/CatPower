//
// Created by Danil on 2019-05-22.
// Copyright (c) 2019 DeadMolesStudio. All rights reserved.
//

import Foundation

let MONEY_SERVICE_KEY = "MONEY_SERVICE_KEY"
let MONEY_SERVICE_INCOMES_KEY = MONEY_SERVICE_KEY + "_INCOMES"
let MONEY_SERVICE_COSTS_KEY = MONEY_SERVICE_KEY + "_COSTS"

fileprivate func ConvertArrays(from strs: [CategoryStr]) -> [Category] {
    var result = [Category]()
    for item in strs {
        result.append(Category(fromCategoryStr: item))
    }
    return result
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
        let defaults = UserDefaults.standard
        if let ms = defaults.data(forKey: MONEY_SERVICE_INCOMES_KEY) {
            self.incomes = NSKeyedUnarchiver.unarchiveObject(with: ms) as! [Category]
        } else {
            self.incomes = ConvertArrays(from: incomeDefaultCategories)
        }
        if let ms = defaults.data(forKey: MONEY_SERVICE_COSTS_KEY) {
            self.costs = NSKeyedUnarchiver.unarchiveObject(with: ms) as! [Category]
        } else {
            self.costs = ConvertArrays(from: costsDefaultCategories)
        }
//        if let ms = defaults.object(forKey: MONEY_SERVICE_KEY) as? MoneyService {
//            self.incomes = ms.incomes
//            self.costs = ms.costs
//        } else {
//            self.costs = ConvertArrays(from: costsDefaultCategories)
//            self.incomes = ConvertArrays(from: incomeDefaultCategories)
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

    func transfer(from: Category, to: Category, value: Int) throws {
        var from_category: Category
        if let cat = self.getCategory(by: from, from: self.incomes) {
            from_category = cat
        } else if let cat = self.getCategory(by: from, from: self.costs) {
            from_category = cat
        } else {
            throw MoneyServiceError.CategoryNotExists
        }
        var to_category: Category
        if let cat = self.getCategory(by: to, from: self.incomes) {
            to_category = cat
        } else if let cat = self.getCategory(by: to, from: self.costs) {
            to_category = cat
        } else {
            throw MoneyServiceError.CategoryNotExists
        }
        from.value -= value
        to.value += value
        self.save()
        let op = Operation(from: from, to: to, value: value, comment: nil)
        History.GetHistory().addOperation(operation: op)
    }

    func transfer(fromString: String, toString: String, value: Int) throws {
        let from = Category()
        from.name = fromString
        let to = Category()
        from.name = toString
        try self.transfer(from: from, to: to, value: value)
    }

    func addMoney(to category: Category, amount money: Int) {
        category.value += money
        self.save()
    }
}

