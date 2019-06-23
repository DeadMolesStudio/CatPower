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
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 5
    button.layer.borderColor = UIColor.blue.cgColor
    return button
}

func CreateRemoveButton(text: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(text, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
//    button.backgroundColor = .red
    button.layer.borderColor = UIColor.red.cgColor
    button.layer.cornerRadius = 5
    button.layer.borderWidth = 1
    button.titleLabel?.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) // doesnt work
    return button
}
