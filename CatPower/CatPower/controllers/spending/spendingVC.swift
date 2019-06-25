//
//  detailedSpendingVC.swift
//  CatPower
//
//  Created by Кирилл Гаджиев on 13/06/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import Foundation
import UIKit

class SpendingVC: UIViewController {
    
//    var fromLabel: UILabel = UILabel()
//    var toLabel: UILabel = UILabel()
    var operationID: UUID!
    var fromTo: FromToView!
    var fromToText: String = "⟶ ? ⟶"
    var amount: UITextField = UITextField()
    var defaultAmountValue: String! = nil
//    var applyButton: UIButton = UIButton()
    var applyButton: UIBarButtonItem = UIBarButtonItem(title: "Ok", style: .done, target: self, action: #selector(GoToMainViewFromSpendingVC))

    var cameraButton: UIButton = UIButton()
    var cameraHandler: CameraHandler = CameraHandler()
    var photoMini: UIImageView = UIImageView(image: UIImage(named: "default.png"))
    var scrollView: UIScrollView = UIScrollView()

    var from: String = ""
    var to: String = ""
    var ms: MoneyService = MoneyService.GetService()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    func setupViews() {
        //Add and setup scroll view
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
        
        //Constrain scroll view
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true;
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90).isActive = true;
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true;
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true;
        

        // Create UI elements
        createItems(view: scrollView)
        // Add constraints to elements
        AddConstraints(view: scrollView)
    }

    
    private func createItems(view: UIView) {
        let operation: Operation = ms.configureOperationByCategories(fromString: from, toString: to)
        self.fromTo = FromToView(frame: CGRect(x: 0 , y: 0, width:  UIScreen.main.bounds.width - 40, height: 100))
        self.fromTo.configure(from: operation)
        self.fromTo.textLabel.text = self.fromToText
        view.addSubview(self.fromTo)

        
        // Create items
        self.amount = CreateTextField(placeholder: "Сколько потратили?")
        if (self.defaultAmountValue != nil) {
            self.amount.text = self.defaultAmountValue
        }
        self.amount.keyboardType = .decimalPad
        view.addSubview(self.amount)
        
        self.cameraButton = CreateDefaultButton(text: "Добавить фото")
        self.cameraButton.addTarget(self, action: #selector(openCamera), for: .allTouchEvents)
        view.addSubview(self.cameraButton)
        
        photoMini.backgroundColor = UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1.0)
        photoMini.layer.borderWidth = 1
        photoMini.layer.borderColor = UIColor.darkGray.cgColor
        photoMini.layer.cornerRadius = 8.0
        photoMini.clipsToBounds = true
        view.addSubview(self.photoMini)
        
        self.navigationItem.rightBarButtonItem = self.applyButton

        cameraHandler.imagePickedBlock = showMini
    }
    
    func AddConstraints(view: UIView) {
        let margin: CGFloat = 30
        view.addConstraints([
            NSLayoutConstraint(item: self.fromTo!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.fromTo!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.fromTo!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: margin),
            ])
        
        //Добавляем зависимость для верхнего элемента чтобы он был привязан к верхушке scrollView и прокурчивался, а не зависал на верху
        self.fromTo.heightAnchor.constraint(equalToConstant: 100)

        
        var previous: Any? = self.fromTo
        for elem in [self.amount, self.cameraButton] {
            view.addConstraints([
                NSLayoutConstraint(item: elem, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: elem, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: elem, attribute: .top, relatedBy: .equal, toItem: previous, attribute: .bottom, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: elem, attribute: .height, relatedBy: .equal,toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50),
                ])
            previous = elem
        }
        
        photoMini.translatesAutoresizingMaskIntoConstraints = false
        photoMini.widthAnchor.constraint(equalToConstant: 150).isActive = true
        photoMini.heightAnchor.constraint(equalToConstant: 150).isActive = true
        photoMini.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoMini.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: margin).isActive = true
    }
    
    
    func showMini(image: UIImage) {
        print("showMini")
        self.photoMini.image = image
    }
    
    @objc private func openCamera() {
        cameraHandler.showActionSheet(vc: self)
    }

    @objc func GoToMainViewFromSpendingVC(sender: UIButton) {
        print("GoToMainViewFromSpendingVC")
        //validating fields
        if (self.amount.text == nil || self.amount.text?.isEmpty == true) {
            self.amount.layer.borderColor = UIColor.red.cgColor
            self.amount.layer.borderWidth = 1.5
            self.amount.layer.cornerRadius = 5
            self.amount.placeholder = "Input amount of spending!"
        } else {
            var money: Int
            if let m = Int(self.amount.text!) {
                money = m
                let photo = self.photoMini.image!
                do {
                    try ms.transfer(fromString: from, toString: to, value: money, photo: photo, id: self.operationID)
                } catch MoneyServiceError.CategoryNotExists {
                    print("error: CategoryExists")
                } catch {
                    print("unhandled error 1")
                    return
                }
            } else {
                return
            }
        }

        print("okolo popview")
        navigationController?.popViewController(animated: true)
        print("posle popview")
    }
    
}
