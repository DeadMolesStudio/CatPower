//
//  CategoryModel.swift
//  CatPower
//
//  Created by k.kazantseva on 24/04/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Category: NSObject, NSCoding {
    var name: String = ""
    var value: Int = 0
    var isIncome: Bool = false
    var picture: String = "cat_ghost.png"

    var strValue: String {
        return String(value) + String(" ₽")
    }

    override init(){
        self.name = ""
        self.value = 0
        self.isIncome = false
        self.picture = "cat_ghost.png"
    }
    init(name: String, value: Int, isIncome: Bool, picture: String){
        self.name = name
        self.value = value
        self.isIncome = isIncome
        self.picture = picture
    }
    init(fromCategoryStr: CategoryStr) {
        self.name = fromCategoryStr.name
        self.isIncome = fromCategoryStr.isIncome
        self.value = fromCategoryStr.value
        self.picture = fromCategoryStr.picture
    }

    init (fromCategory other: Category) {
        self.name = other.name
        self.value = other.value
        self.picture = other.picture
        self.isIncome = other.isIncome
    }
    
    init(fromCategoryEntity: NSManagedObject) {
        self.name = fromCategoryEntity.value(forKey: "name") as? String ?? ""
        self.value = fromCategoryEntity.value(forKey: "value") as? Int ?? 0
        self.picture = fromCategoryEntity.value(forKey: "picture") as? String ?? ""
        self.isIncome = fromCategoryEntity.value(forKey: "isIncome") as? Bool ?? true
    }

    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let picture = aDecoder.decodeObject(forKey: "picture") as! String
        let isIncome = aDecoder.decodeBool(forKey: "isIncome")
        let value = aDecoder.decodeInteger(forKey: "value")
        self.init(name: name, value: value, isIncome: isIncome, picture: picture)
    }

    static func CategoryEntity(fromCategoryStr: CategoryStr, managedContext: NSManagedObjectContext) -> NSManagedObject? {     
        let categoryEntity = NSEntityDescription.entity(forEntityName: "CategoryModel", in: managedContext)!
        let category = NSManagedObject(entity: categoryEntity, insertInto: managedContext)
        category.setValue(fromCategoryStr.isIncome, forKey: "isIncome")
        category.setValue(fromCategoryStr.name, forKey: "name")
        category.setValue(fromCategoryStr.picture, forKey: "picture")
        category.setValue(fromCategoryStr.value, forKey: "value")
        category.setValue(Auth.getCurrentUserEntity(), forKey: "owner")
        return category
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(value, forKey: "value")
        aCoder.encode(picture, forKey: "picture")
        aCoder.encode(isIncome, forKey: "isIncome")
    }
}

struct CategoryStr {
    let name: String
    let value: Int
    let isIncome: Bool
    let picture: String
}

