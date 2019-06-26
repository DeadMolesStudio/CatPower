//
// Created by Danil on 2019-05-04.
// Copyright (c) 2019 DeadMolesStudio. All rights reserved.
//

import Foundation
import UIKit

func CreateTextField(placeholder: String, type: UIKeyboardType = .default) -> UITextField {
    let text = UITextField()
    text.placeholder = placeholder
    text.translatesAutoresizingMaskIntoConstraints = false
    text.borderStyle = UITextField.BorderStyle.roundedRect
    text.keyboardType = type
    return text
}
