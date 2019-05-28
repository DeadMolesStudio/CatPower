//
// Created by Danil on 2019-05-22.
// Copyright (c) 2019 DeadMolesStudio. All rights reserved.
//

import Foundation

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
        let defaults = UserDefaults.standard
        if let h = defaults.data(forKey: HISTORY_SERVICE_KEY) {
            self.Operations = NSKeyedUnarchiver.unarchiveObject(with: h) as! [Operation]
        } else {
            self.Operations = [Operation]()
        }
    }

    private init(operations: [Operation]) {
        Operations = operations
    }


    func save() {
        let defaults = UserDefaults.standard
        let data = NSKeyedArchiver.archivedData(withRootObject: self.Operations)
        defaults.set(data, forKey: HISTORY_SERVICE_KEY)

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
        self.save()
    }

    func removeOperation(operation: Operation) -> Bool {
//        if let (_, i) = self.findOperation(opertation: operation) {
//            self.Operations.remove(at: i)
//        }
//        return true
        let index = self.Operations.firstIndex(where: {$0.id == operation.id})
        if let i = index {
            self.Operations.remove(at: i)
            self.save()
        } else {
            return false
        }
        return true

    }
}

class Operation: NSObject, NSCoding {
    var id: UUID
    var From: Category
    var To: Category
    var Value: Int
//    var Comment: String?

    override init() {
        From = Category()
        To = Category()
        Value = 0
//        Comment = nil
        id = UUID()
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

    init(from: Category, to: Category, value: Int, id: UUID) {
        From = from
        To = to
        Value = value
        self.id = id
    }

    required convenience init(coder aDecoder: NSCoder) {
        let from_category_data = aDecoder.decodeObject(forKey: "From") as! Data
        let from = NSKeyedUnarchiver.unarchiveObject(with: from_category_data) as! Category
        let to_category_data = aDecoder.decodeObject(forKey: "To") as! Data
        let to = NSKeyedUnarchiver.unarchiveObject(with: to_category_data) as! Category
        let id = aDecoder.decodeObject(forKey: "id") as! UUID
        let value = aDecoder.decodeInteger(forKey: "Value")
        self.init(from: from, to: to, value: value, id: id)
    }

    func encode(with aCoder: NSCoder) {
        let from_category_data = NSKeyedArchiver.archivedData(withRootObject: self.From)
        let to_category_data = NSKeyedArchiver.archivedData(withRootObject: self.To)
        aCoder.encode(from_category_data, forKey: "From")
        aCoder.encode(to_category_data, forKey: "To")
        aCoder.encode(Value, forKey: "Value")
        aCoder.encode(id, forKey: "id")
    }

    static func == (lhs: Operation, rhs: Operation) -> Bool {
        return lhs.id == rhs.id
    }

    func save() {
        // TODO: save this operation to db
    }

}
