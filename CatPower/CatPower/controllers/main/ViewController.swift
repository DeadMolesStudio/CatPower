//
//  ViewController.swift
//  CatPower
//
//  Created by k.kazantseva on 22/04/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//


import UIKit
import CoreData

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
//        UserDefaults.standard.removeObject(forKey: TOKEN_KEY)
        self.collectionView.dragDelegate = self
        self.collectionView.dropDelegate = self
        self.collectionView.dragInteractionEnabled = true
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserModel")
        
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "username") as! String)
                print(data.value(forKey: "email") as! String)
                print(data.value(forKey: "password") as! String)
            }
        } catch {
            print("Failed")
        }
        
    }

    private func setupNavBarItems() {

        let sideBarPicture = UIImage(named: "bars.png")
        sidebarButton.tintColor = UIColor.gray
        sidebarButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        sidebarButton.setBackgroundImage(sideBarPicture, for: .normal)
        sidebarButton.addTarget(self, action: #selector(goToHistory), for: .touchUpInside)

        let addMoneyPicture = UIImage(named: "money.png")
        addMoneyButton.tintColor = UIColor.gray
        addMoneyButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        addMoneyButton.setBackgroundImage(addMoneyPicture, for: .normal)
        addMoneyButton.addTarget(self, action: #selector(addMoney), for: .touchUpInside)

    }
    var isPushing = false
    @objc func goToHistory(sender: UIButton) {
        // isPushing и транзакции против двойного пуша одной и той же вьюшки
        if !isPushing {
            isPushing = true
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.isPushing = false
            }
            
            let vc = HistoryView.init(collectionViewLayout: GridLayout())
//            let vc = storyboard?.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryView
//            vc.collectionViewLayout = GridLayout()
            vc.view.backgroundColor = UIColor.white
            self.navigationController?.pushViewController(vc, animated: true)
            CATransaction.commit()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
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
            textField.placeholder = "Amount"
            textField.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if pickerView.numberOfRows(inComponent: 0) == 0 {
                return
            }
            if let text = textField {
                let category = MoneyService.GetService().incomes[pickerView.selectedRow(inComponent: 0)]

                if let money = Int(text.text!) {
                    MoneyService.GetService().addMoney(to: category, amount: money)
                    self.collectionView.reloadData()
                } else {
                    return
                }
            } else {
                return
            }
//            let category = MoneyService.GetService().incomes[pickerView.selectedRow(inComponent: 0)]
//            let money = Int(textField!.text!)!
//            MoneyService.GetService().addMoney(to: category, amount: money)
//            self.collectionView.reloadData()
        }))
        self.present(alert, animated: true)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true, completion: nil)
        }))
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

    private func setBalanceInfo(newCosts: Int = 0, newBalance: Int = 0) {
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

        let newBalance = MoneyService.GetService().incomes.map {$0.value}.reduce(0) {$0+$1}
        let newCosts = MoneyService.GetService().costs.map {$0.value}.reduce(0) {$0+$1}
        self.setBalanceInfo(newCosts: newCosts, newBalance: newBalance)

        return cell;

    }

    @objc func tapAddCategory(_ sender: UITapGestureRecognizer) {

        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)

        if let index = indexPath {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: index) as! MoneyView
            let alert = UIAlertController(title: "Add Category", message: "Enter a category name", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Category name"
            }
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                var category = Category()
                category.value = 0
                category.name = textField!.text!
                if category.name.count == 0 {
                    let alert2 = UIAlertController(title: "Error", message: "No name provided", preferredStyle: .alert)
                    alert2.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert2, animated: true)
                    return
                }
                if category.name.count > 12 {
                    let alert2 = UIAlertController(title: "Error", message: "Name to long (>12)", preferredStyle: .alert)
                    alert2.addAction(UIAlertAction(title: "OK", style: .default))
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
                        let alert2 = UIAlertController(title: "Error", message: "This category exists", preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "OK", style: .default))
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
                        let alert2 = UIAlertController(title: "Error", message: "This category exists", preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert2, animated: true)
                    } catch {
                        print("Unhandeled error")
                    }
                default:
                    category.isIncome = false
                }
                self.collectionView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
                alert?.dismiss(animated: true, completion: nil)
            }))
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //чтобы всегда было по 4 ячейки в ряду
        let cellWidth = (self.view.frame.size.width - 45 - 40) / 4;

        let size = CGSize(width: cellWidth, height: cellWidth * 1.3)
        return size
    }


}

extension ViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item: Category
        if indexPath.section == 0 {
            item = self.incomeData[indexPath.row]
        } else {
            item = self.costsData[indexPath.row]
        }
        let itemProvider = NSItemProvider(object: item.name as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension ViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if self.collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .unspecified)
        } else {
            return UICollectionViewDropProposal(operation: .move)
        }

    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        let cell = collectionView.cellForItem(at: destinationIndexPath) as! MoneyView
        let source_cell: MoneyView
        if coordinator.items.count == 1, let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
            source_cell = collectionView.cellForItem(at: sourceIndexPath) as! MoneyView
        } else {
            source_cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! MoneyView
        }
//        do {
//            try ms.transfer(fromString: source_cell.categoryName!.text!, toString: cell.categoryName!.text!, value: 1)
//        } catch MoneyServiceError.CategoryNotExists {
//            print("error: CategoryExists")
//        } catch {
//            print("unhandled error 1")
//            return
//        }
        switch coordinator.proposal.operation {
        case .move:
//            let alert = UIAlertController(title: "Amount", message: "Enter amount", preferredStyle: .alert)
//            alert.addTextField { (textField) in
//                textField.placeholder = "amount"
//                textField.keyboardType = .decimalPad
//            }
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
//                var money: Int?
//                let textField = alert?.textFields![0]
//                if let text = textField {
//                    if let m = Int(text.text!) {
//                        money = m
//                    } else {
//                        return
//                    }
//                } else {
//                    return
//                }
//                if let value = money {
//                    do {
//                        try ms.transfer(fromString: source_cell.categoryName.text!, toString: cell.categoryName.text!, value: value)
//                        self.collectionView.reloadData()
//                    } catch MoneyServiceError.CategoryNotExists {
//                        print("error: CategoryExists")
//                    } catch {
//                        print("unhandled error 1")
//                        return
//                    }
//                } else {
//                    let alert2 = UIAlertController(title: "error", message: "Bad value! Integers only", preferredStyle: .alert)
//                    alert2.addAction(UIAlertAction(title: "ok", style: .default))
//                    self.present(alert2, animated: true)
//                    return
//                }
//
//            }))
//            alert.addAction(UIAlertAction(title: "cancel", style: .default))
//            present(alert, animated: true)
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "SpendingVC") as! SpendingVC
            vc.from = source_cell.categoryName.text!
            vc.to = cell.categoryName.text!
            vc.view.backgroundColor = UIColor.white
            navigationController?.pushViewController(vc, animated: true)
            
            break
        default:
            return
        }
    }
}
