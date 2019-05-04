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
    return button
}