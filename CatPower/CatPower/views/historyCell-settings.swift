//
// Created by Danil on 2019-05-28.
// Copyright (c) 2019 DeadMolesStudio. All rights reserved.
//

import Foundation
import UIKit

func HistoryCellLabel() -> UILabel {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 10)
    label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    return label
}

func HistoryCellImage() -> UIImageView {
    let iv =  UIImageView(frame: CGRect.zero)
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.contentMode = .scaleAspectFill
    iv.isUserInteractionEnabled = false
    return iv
}