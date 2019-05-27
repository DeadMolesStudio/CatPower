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
        if let h = defaults.object(forKey: HISTORY_SERVICE_KEY) as? History {
            self.Operations = h.Operations
        } else {
            self.Operations = [Operation]()
        }
    }

    private init(operations: [Operation]) {
        Operations = operations
    }


    func save() {
        let defaults = UserDefaults.standard
        defaults.set(self, forKey: HISTORY_SERVICE_KEY)

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
        if let (_, i) = self.findOperation(opertation: operation) {
            self.Operations.remove(at: i)
        }
        return true
    }
}

class Operation {
    var id: UUID
    var From: Category
    var To: Category
    var Value: Int
    var Comment: String?

    init() {
        From = Category()
        To = Category()
        Value = 0
        Comment = nil
        id = UUID()
    }

    init(from: Category, to: Category, value: Int, comment: String?) {
        From = from
        To = to
        if let c = comment {
            Comment = c
        }
        Value = value
        id = UUID()
    }

    static func == (lhs: Operation, rhs: Operation) -> Bool {
        return lhs.id == rhs.id
    }

    func save() {
        // TODO: save this operation to db
    }

}
