//
// Created by Danil on 2019-05-22.
// Copyright (c) 2019 DeadMolesStudio. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let HISTORY_SERVICE_KEY = "HISTORY_SERVICE_KEY"

class History {
    var Operations: [Operation]

    static private var storage: History = {
        let h = History()
        return h
    }()

    class func GetHistory() -> History {
        return self.storage
    }

    private init() {
//        let defaults = UserDefaults.standard
        
        self.Operations = getCurrentUserOperations()
        
//        if let h = defaults.data(forKey: HISTORY_SERVICE_KEY) {
//            self.Operations =
////            self.Operations = NSKeyedUnarchiver.unarchiveObject(with: h) as! [Operation]
//        } else {
//            self.Operations = [Operation]()
//        }
    }

    private init(operations: [Operation]) {
        Operations = operations
    }


    func save() {
//        let defaults = UserDefaults.standard
//        let data = NSKeyedArchiver.archivedData(withRootObject: self.Operations)
//        defaults.set(data, forKey: HISTORY_SERVICE_KEY)

        // TODO: make request to API to save

    }

    func findOperation(opertation: Operation) -> (Operation, Int)? {

        let i = self.Operations.firstIndex {$0 == opertation}
        if let i = i {
            return (self.Operations[i], i)
        }
        return nil
    }

    func addOperation(operation: Operation) {
        self.Operations.append(operation)
        self.addOperationToCoreData(operation)
        self.save()
    }
    
    func addOperationToCoreData(_ newOperation: Operation) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let operationEntity = NSEntityDescription.entity(forEntityName: "OperationModel", in: managedContext)!
        
        let operation = NSManagedObject(entity: operationEntity, insertInto: managedContext)
        operation.setValue(newOperation.Value, forKey: "value")
        operation.setValue(newOperation.id, forKey: "id")
        
        operation.setValue(newOperation.Photo!.pngData() ?? UIImage(named: "default.png")?.pngData(), forKey: "photo")
        
//        if newOperation.Photo != nil {
//            if let data = newOperation.Photo!.pngData() {
//
////                let filename = getDocumentsDirectory().appendingPathComponent(newOperation.id.uuidString + ".png")
//               let filename = newOperation.id.uuidString + ".png"
//
//                do {
//                    try data.write(to: URL(string: filename)!)
//                } catch {
//                    print("FAIL WHILE WRITE TO FILE")
//                }
//
//                operation.setValue(filename, forKey: "photo")
//            }
//        } else {
//            operation.setValue("default.png", forKey: "photo")
//
//        }
        
        let currentUserEntity = Auth.getCurrentUserEntity()
        operation.setValue(currentUserEntity, forKey: "owner")
        
        let from = newOperation.FromEntity!
        operation.setValue(from, forKey: "from")

//        print("from: ", from.value(forKey: "name"))
        var curFromValue = from.value(forKey: "value") as! Int
        curFromValue -= newOperation.Value
        from.setValue(curFromValue, forKey: "value")
        
        let to = newOperation.ToEntity!
        operation.setValue(to, forKey: "to")

//        print("to: ", to.value(forKey: "name"))

        var curToValue = to.value(forKey: "value") as! Int
        curToValue += newOperation.Value
        to.setValue(curToValue, forKey: "value")

        
        
        
        
        do {
            try managedContext.save()
        } catch {
            print("Failed save in SinupVC")
        }
    }
    
    func removeOperationFromCoreData(_ operationToRemove: Operation) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let currentUsername = Auth.getCurrentUserEntity()?.value(forKey: "username") as? String ?? "ANON"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OperationModel")
        let uuidPredicate = NSPredicate(format: "id=%@", operationToRemove.id.uuidString)
        let ownerPredicate = NSPredicate(format: "owner.username=%@", currentUsername)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [ownerPredicate, uuidPredicate])
        
        fetchRequest.predicate = andPredicate
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                managedContext.delete(data)
            }
            do {
                try managedContext.save()
            } catch {
                print("FAILED WHILE SAVE IN DELETE OPERATOIN")
            }
        } catch {
            print("Failed")
        }
    }
    
    func addOrUpdateOperation(operation: Operation) {
        let index = self.Operations.firstIndex(where: {$0.id == operation.id})
        print("operationID: ", operation.id, " addOrUpdate. operations: ")
        for op in self.Operations {
            print(op.id)
        }
        if index != nil {
            let findAndDeleted = self.removeOperation(operation: operation)
            print("FIND AND REMOVE WHILE UPDATE:", findAndDeleted)
        }
        self.addOperation(operation: operation)
    }

    func removeOperation(operation: Operation) -> Bool {
//        if let (_, i) = self.findOperation(opertation: operation) {
//            self.Operations.remove(at: i)
//        }
//        return true
        let index = self.Operations.firstIndex(where: {$0.id == operation.id})
        if let i = index {
            self.Operations.remove(at: i)
        } else {
            return false
        }
        
        self.removeOperationFromCoreData(operation)
        
        return true

    }
}

class Operation: NSObject, NSCoding {
    var id: UUID
    var From: Category
    var To: Category
    var Value: Int
    var Photo: UIImage?
//    var Comment: String?

    override init() {
        From = Category()
        To = Category()
        Value = 0
//        Comment = nil
        id = UUID()
    }
    
    init(from: Category, to: Category, value: Int, photo: UIImage) {
        From = from
        To = to
        //        if let c = comment {
        //            Comment = c
        //        }
        Value = value
        id = UUID()
        Photo = photo
    }

    init(from: Category, to: Category, value: Int) { //, comment: String?) {
        From = from
        To = to
//        if let c = comment {
//            Comment = c
//        }
        Value = value
        id = UUID()
    }

    init(from: Category, to: Category, value: Int, id: UUID, photo: UIImage) {
        From = from
        To = to
        Value = value
        Photo = photo
        self.id = id
    }

    required convenience init(coder aDecoder: NSCoder) {
        let from_category_data = aDecoder.decodeObject(forKey: "From") as! Data
        let from = NSKeyedUnarchiver.unarchiveObject(with: from_category_data) as! Category
        let to_category_data = aDecoder.decodeObject(forKey: "To") as! Data
        let to = NSKeyedUnarchiver.unarchiveObject(with: to_category_data) as! Category
        let photo_data = aDecoder.decodeObject(forKey: "Photo") as! Data
        let photo_png_data = NSKeyedUnarchiver.unarchiveObject(with: photo_data) as! Data
        let photo = UIImage(data: photo_png_data) ?? UIImage()
        
        let id = aDecoder.decodeObject(forKey: "id") as! UUID
        let value = aDecoder.decodeInteger(forKey: "Value")
        self.init(from: from, to: to, value: value, id: id, photo: photo)
    }

    func encode(with aCoder: NSCoder) {
        let from_category_data = NSKeyedArchiver.archivedData(withRootObject: self.From)
        let to_category_data = NSKeyedArchiver.archivedData(withRootObject: self.To)
        let photo_data = NSKeyedArchiver.archivedData(withRootObject: self.Photo?.pngData())
        aCoder.encode(from_category_data, forKey: "From")
        aCoder.encode(to_category_data, forKey: "To")
        aCoder.encode(photo_data, forKey: "Photo")
        aCoder.encode(Value, forKey: "Value")
        aCoder.encode(id, forKey: "id")
    }

    static func == (lhs: Operation, rhs: Operation) -> Bool {
        return lhs.id == rhs.id
    }

    func save() {
        // TODO: save this operation to db
    }
    
    var FromEntity: NSManagedObject? {
        get {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
            let managedContext = appDelegate.persistentContainer.viewContext
        
            
            let currentUsername = Auth.getCurrentUserEntity()?.value(forKey: "username") as? String ?? "ANON"
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryModel")
            let namePredicate = NSPredicate(format: "name=%@", self.From.name)
            let ownerPredicate = NSPredicate(format: "owner.username=%@", currentUsername)
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [ownerPredicate, namePredicate])

            fetchRequest.predicate = andPredicate
        
            do {
                let result = try managedContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    return data
                }
            } catch {
                print("Failed")
            }
            
            let categoryEntity = NSEntityDescription.entity(forEntityName: "CategoryModel", in: managedContext)!
            
            let category = NSManagedObject(entity: categoryEntity, insertInto: managedContext)
            category.setValue(self.From.isIncome, forKey: "isIncome")
            category.setValue(self.From.name, forKey: "name")
            category.setValue(self.From.picture, forKey: "picture")
            category.setValue(self.From.value, forKey: "value")
            category.setValue(Auth.getCurrentUserEntity(), forKey: "owner")

            do {
                try managedContext.save()
            } catch {
                print("Failed save in SinupVC")
            }
            
            return category
        }
    }

    var ToEntity: NSManagedObject? {
        get {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let currentUsername = Auth.getCurrentUserEntity()?.value(forKey: "username") as? String ?? "ANON"
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryModel")
            let namePredicate = NSPredicate(format: "name=%@", self.To.name)
            let ownerPredicate = NSPredicate(format: "owner.username=%@", currentUsername)
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [ownerPredicate, namePredicate])
            
            fetchRequest.predicate = andPredicate
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    return data
                }
            } catch {
                print("Failed")
            }
            
            let categoryEntity = NSEntityDescription.entity(forEntityName: "CategoryModel", in: managedContext)!
            
            let category = NSManagedObject(entity: categoryEntity, insertInto: managedContext)
            category.setValue(self.To.isIncome, forKey: "isIncome")
            category.setValue(self.To.name, forKey: "name")
            category.setValue(self.To.picture, forKey: "picture")
            category.setValue(self.To.value, forKey: "value")
            category.setValue(Auth.getCurrentUserEntity(), forKey: "owner")

            
            do {
                try managedContext.save()
            } catch {
                print("Failed save in SinupVC")
            }
            
            return category
        }
    }

    
}

func getCurrentUserOperations() -> [Operation] {
    guard let currentUserEntity = Auth.getCurrentUserEntity() else {
        print("NO USER ENTITY")
        return [Operation]()
    }

    let currentUsername = currentUserEntity.value(forKey: "username") as! String
    print("currentUsername: ", currentUsername)

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [Operation]() }
    let managedContext = appDelegate.persistentContainer.viewContext

    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OperationModel")
    fetchRequest.predicate = NSPredicate(format: "owner.username=%@", currentUsername)

    var operationsFromCoreData = [Operation]()

    do {
        let result = try managedContext.fetch(fetchRequest)
        for data in result as! [NSManagedObject] {
            let fromCategoryEntity = data.value(forKey: "from") as! NSManagedObject
            let fromCategory = Category(
                name: fromCategoryEntity.value(forKey: "name") as! String,
                value: fromCategoryEntity.value(forKey: "value") as! Int,
                isIncome: fromCategoryEntity.value(forKey: "isIncome") as! Bool,
                picture: fromCategoryEntity.value(forKey: "picture") as! String
            )

            let toCategoryEntity = data.value(forKey: "to") as! NSManagedObject
            let toCategory = Category(
                name: toCategoryEntity.value(forKey: "name") as! String,
                value: toCategoryEntity.value(forKey: "value") as! Int,
                isIncome: toCategoryEntity.value(forKey: "isIncome") as! Bool,
                picture: toCategoryEntity.value(forKey: "picture") as! String
            )

            let photoData = data.value(forKey: "photo") as! Data
            let op = Operation(
                from: fromCategory,
                to: toCategory,
                value: data.value(forKey: "value") as! Int,
                id: data.value(forKey: "id") as! UUID,
                photo: UIImage(data: photoData) ?? UIImage()
            )
            operationsFromCoreData.append(op)
        }
    } catch {
        print("Failed")
    }
    return operationsFromCoreData
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
