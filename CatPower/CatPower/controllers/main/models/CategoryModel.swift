//
//  CategoryModel.swift
//  CatPower
//
//  Created by k.kazantseva on 24/04/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import Foundation

class Category {
    var name: String = ""
    var value: Int = 0
    var isIncome: Bool = false
    var picture: String = "cat_ghost.png"

    var strValue: String {
        return String(value) + String(" ₽")
    }

    init(){
        self.name = ""
        self.value = 0
        self.isIncome = false
        self.picture = "cat_ghost.png"
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

}

struct CategoryStr {
    let name: String
    let value: Int
    let isIncome: Bool
    let picture: String
}

