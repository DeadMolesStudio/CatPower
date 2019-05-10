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
}

struct CategoryStr {
    let name: String
    let value: Int
    let isIncome: Bool
    let picture: String
}

