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
    
    var incomeData = [Category]()
    var costsData = [Category]()

    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.incomeData = MoneyService.GetService().incomes
        self.costsData = MoneyService.GetService().costs
        setupNavBarItems()
        setBalanceInfo()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
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
            return MoneyService.GetService().incomes.count + 1;
        default:
            return MoneyService.GetService().costs.count + 1;
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoneyView
        
        if indexPath.section == 0 {
            let isIndexValid = incomeData.indices.contains(indexPath.item)
            if isIndexValid {
                let dataItem = incomeData[indexPath.item]
                let model = Category(fromCategory: dataItem)
                cell.fillCell(with: model)
                cell.tag = indexPath.item
            } else {
                let dataItem = Category()
                dataItem.name = "Add Category"
                dataItem.isIncome = true
                dataItem.value = 0
                dataItem.picture = "shadow_fly.png"
                cell.fillCell(with: dataItem)
                cell.value.text = ""
                cell.tag = indexPath.item
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
            }
        }

        if indexPath.section == 1 {
            let isIndexValid = costsData.indices.contains(indexPath.item)
            if isIndexValid {
                let dataItem = costsData[indexPath.item]
                let model = Category(fromCategory: dataItem)
                cell.fillCell(with: model)
                cell.tag = indexPath.item
            } else {
                let dataItem = Category()
                dataItem.name = "Add Category"
                dataItem.isIncome = false
                dataItem.value = 0
                dataItem.picture = "shadow_fly.png"
                cell.fillCell(with: dataItem)
                cell.value.text = ""
                cell.tag = indexPath.item
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
            }
        }

        return cell;
        
    }

    @objc func tap(_ sender: UITapGestureRecognizer) {

        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)

        if let index = indexPath {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: index) as! MoneyView
            print("Got clicked on index: \(index)!")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //чтобы всегда было по 4 ячейки в ряду
        let cellWidth = (self.view.frame.size.width - 45 - 40)/4;
        
        let size = CGSize(width: cellWidth, height: cellWidth * 1.3)
        return size
    }


}

