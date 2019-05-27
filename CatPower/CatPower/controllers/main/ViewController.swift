//
//  ViewController.swift
//  CatPower
//
//  Created by k.kazantseva on 22/04/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        addMoneyButton.addTarget(self, action: #selector(addMoney), for: .allTouchEvents)
        
    }

    @objc func addMoney(sender: UIButton) {

        let alert = UIAlertController(title: "Select category", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 162))
        pickerView.dataSource = self
        pickerView.delegate = self

// comment this line to use white color
        pickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        alert.view.addSubview(pickerView)
        alert.addTextField { (textField) in
            textField.placeholder = "amount"
        }
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if let text = textField {
                let category = MoneyService.GetService().incomes[pickerView.selectedRow(inComponent: 0)]

                if let money = Int(text.text!) {
                    MoneyService.GetService().addMoney(to: category, amount: money)
                    self.collectionView.reloadData()
                    print("amount = \(Int(text.text!)!)")
                    print("category \(category.name)")
                } else {
                    return
                }
            } else {
                return
            }
            let category = MoneyService.GetService().incomes[pickerView.selectedRow(inComponent: 0)]
            let money = Int(textField!.text!)!
            MoneyService.GetService().addMoney(to: category, amount: money)
            self.collectionView.reloadData()
            print("amount = \(Int(textField!.text!)!)")
            print("category \(category.name)")
        }))
        self.present(alert, animated: true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MoneyService.GetService().incomes.count;
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return MoneyService.GetService().incomes[row].name as String
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
        self.incomeData = MoneyService.GetService().incomes
        self.costsData = MoneyService.GetService().costs
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
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAddCategory)))
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
                cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAddCategory)))
            }
        }

        return cell;
        
    }

    @objc func tapAddCategory(_ sender: UITapGestureRecognizer) {

        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)

        if let index = indexPath {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: index) as! MoneyView
            let alert = UIAlertController(title: "Add Category", message: "Enter a category name", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "category name"
            }
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                var category = Category()
                category.value = 0
                category.name = textField!.text!
                if category.name.count == 0 {
                    let alert2 = UIAlertController(title: "error", message: "No name provided", preferredStyle: .alert)
                    alert2.addAction(UIAlertAction(title: "ok", style: .default))
                    self.present(alert2, animated: true)
                    return
                }
                if category.name.count > 12 {
                    let alert2 = UIAlertController(title: "error", message: "Name to long(>12)", preferredStyle: .alert)
                    alert2.addAction(UIAlertAction(title: "ok", style: .default))
                    self.present(alert2, animated: true)
                    return
                }
                category.picture = {
                    let randIndex = Int(arc4random_uniform(UInt32(available_images.count)))
                    return available_images[randIndex]
                }()
                switch index.section {
                case 0:
                    category.isIncome = true
                    do {
                        try MoneyService.GetService().addIncomeCategory(with: category)
                    } catch MoneyServiceError.NameExists {
                        print("name exists ")
                        let alert2 = UIAlertController(title: "error", message: "This category exists", preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "ok", style: .default))
                        self.present(alert2, animated: true)
                    } catch {
                        print("Unhandeled error")
                    }
                case 1:
                    category.isIncome = false
                    do {
                        try MoneyService.GetService().addCostCategory(with: category)
                    } catch MoneyServiceError.NameExists {
                        print("name exists ")
                        let alert2 = UIAlertController(title: "error", message: "This category exists", preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "ok", style: .default))
                        self.present(alert2, animated: true)
                    } catch {
                        print("Unhandeled error")
                    }
                default:
                    category.isIncome = false
                }
                print("reloading views")
                self.collectionView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)

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

