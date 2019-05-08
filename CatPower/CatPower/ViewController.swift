//
//  ViewController.swift
//  CatPower
//
//  Created by k.kazantseva on 22/04/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var sidebarButton: UIButton!
    @IBOutlet weak var addMoneyButton: UIButton!
    
    @IBOutlet weak var costsValue: UILabel!
    @IBOutlet weak var balanceValue: UILabel!
    
    var incomeData = [CategoryStr]()
    var costsData = [CategoryStr]()

    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.incomeData = incomeDefaultCategories
        self.costsData = costsDefaultCategories
        setupNavBarItems()
        setBalanceInfo()
        // для дебага, кажыдй раз после логина удаляем ключ чтобы проверить авторизацию при новом запуске
        UserDefaults.standard.removeObject(forKey: TOKEN_KEY)
    }
    
    private func setupNavBarItems() {
        
        let sideBarPicture = UIImage(named: "bars.png")
        sidebarButton.tintColor = UIColor.gray
        sidebarButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        sidebarButton.setBackgroundImage(sideBarPicture, for: .normal)
        
        let addMoneyPicture = UIImage(named: "money.png")
        addMoneyButton.tintColor = UIColor.gray
        addMoneyButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        addMoneyButton.setBackgroundImage(addMoneyPicture, for: .normal)
        
    }
    
    private func setBalanceInfo(newCosts : Int = 0, newBalance : Int = 0) {
        costsValue.text = String(newCosts) + String(" ₽")
        balanceValue.text = String(newBalance) + String(" ₽")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2;
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2;
        default:
            return 7;
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoneyView
        
        if indexPath.section == 0 {
            let isIndexValid = incomeData.indices.contains(indexPath.item)
            if isIndexValid {
                let dataItem = incomeData[indexPath.item]
                let model = Category()
                model.name = dataItem.name
                model.isIncome = dataItem.isIncome
                model.picture = dataItem.picture
                model.value = dataItem.value
                
                cell.fillCell(with: model)
                cell.tag = indexPath.item
            }
        }
        
        if indexPath.section == 1 {
            let isIndexValid = costsData.indices.contains(indexPath.item)
            if isIndexValid {
                let dataItem = costsData[indexPath.item]
                let model = Category()
                model.name = dataItem.name
                model.isIncome = dataItem.isIncome
                model.picture = dataItem.picture
                model.value = dataItem.value
                
                cell.fillCell(with: model)
                cell.tag = indexPath.item
            }
        }
        
//        cell.value.text = String("100 ₽")
//        cell.categoryName.text = String("Кошелек")
//        cell.categoryPicture.image = UIImage(named: "cat_acrobat.png")
        
        
        
        return cell;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //чтобы всегда было по 4 ячейки в ряду
        let cellWidth = (self.view.frame.size.width - 45 - 40)/4;
        
        let size = CGSize(width: cellWidth, height: cellWidth * 1.3)
        return size
    }


}

