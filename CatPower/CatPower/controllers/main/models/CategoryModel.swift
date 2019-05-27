//
//  CategoryModel.swift
//  CatPower
//
//  Created by k.kazantseva on 24/04/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import Foundation

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

    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let picture = aDecoder.decodeObject(forKey: "picture") as! String
        let isIncome = aDecoder.decodeBool(forKey: "isIncome")
        let value = aDecoder.decodeInteger(forKey: "value")
        self.init(name: name, value: value, isIncome: isIncome, picture: picture)
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

