//
//  MoneyView.swift
//  CatPower
//
//  Created by k.kazantseva on 22/04/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import UIKit

class MoneyView: UICollectionViewCell {
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryPicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryName.textColor = UIColor.gray
        categoryName.font = UIFont.boldSystemFont(ofSize: 10)
        
        value.font = UIFont.boldSystemFont(ofSize: 12)
        value.textColor = UIColor(red: 1, green: 0.721, blue: 0.254, alpha: 1)
        
    }
    
    func incomeColor() {
        value.textColor = UIColor(red: 1, green: 0.721, blue: 0.254, alpha: 1)
    }
    
    func costsColor() {
        value.textColor = UIColor(red: 0, green: 0.658, blue: 0.419, alpha: 1)
    }
    
    func fillCell(with model: Category) {
        value.text = model.strValue
        categoryName.text = model.name
        categoryPicture.image = UIImage(named: model.picture)
        if model.isIncome {
            incomeColor()
        } else {
            costsColor()
        }
    }

}
    



