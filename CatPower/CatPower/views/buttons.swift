//
// Created by Danil on 2019-05-04.
// Copyright (c) 2019 DeadMolesStudio. All rights reserved.
//

import Foundation
import UIKit


// Customize button here
func CreateDefaultButton(text: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(text, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    // для дебага
    button.layer.borderWidth = 3
    button.layer.borderColor = UIColor.blue.cgColor
    return button
}

func CreateRemoveButton(text: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(text, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .red
    button.titleLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    return button
}