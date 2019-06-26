//
// Created by Danil on 2019-05-28.
// Copyright (c) 2019 DeadMolesStudio. All rights reserved.
//

import Foundation
import UIKit

class HistoryCell: UICollectionViewCell {

    static let Id = "HistoryCell"
    var operation = Operation()
    var from_image = HistoryCellImage()
    var to_image = HistoryCellImage()
    var deleteButton = CreateRemoveButton(text: "Remove")
    var textLabel = HistoryCellTouchable()
    var from_name = HistoryCellLabel()
    var to_name = HistoryCellLabel()
    var parentVC: UIViewController?
    var storyboard: UIStoryboard?

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init")
        contentView.addSubview(from_image)
        contentView.addSubview(to_image)
        contentView.addSubview(textLabel)
        contentView.addSubview(deleteButton)
        contentView.addSubview(from_name)
        contentView.addSubview(to_name)

//        textLabel.font = UIFont.boldSystemFont(ofSize: 20)

        from_image.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant: 10).isActive = true
//        from_image.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        from_image.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        from_image.widthAnchor.constraint(equalToConstant:64).isActive = true
        from_image.heightAnchor.constraint(equalToConstant:64).isActive = true

        from_name.widthAnchor.constraint(equalTo: from_image.widthAnchor).isActive = true
        from_name.topAnchor.constraint(equalTo: from_image.bottomAnchor, constant: 10).isActive = true
        from_name.leadingAnchor.constraint(equalTo: from_image.leadingAnchor).isActive = true

        to_image.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant: 10).isActive = true
        to_image.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        to_image.widthAnchor.constraint(equalToConstant:64).isActive = true
        to_image.heightAnchor.constraint(equalToConstant:64).isActive = true
        
        to_name.widthAnchor.constraint(equalTo: to_image.widthAnchor).isActive = true
        to_name.topAnchor.constraint(equalTo: to_image.bottomAnchor, constant: 10).isActive = true
        to_name.leadingAnchor.constraint(equalTo: to_image.leadingAnchor).isActive = true


        textLabel.centerYAnchor.constraint(equalTo: from_image.centerYAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalTo: from_image.heightAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: from_image.trailingAnchor, constant: 10).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: to_image.leadingAnchor, constant: -10).isActive = true
        

        deleteButton.centerYAnchor.constraint(equalTo: from_name.centerYAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalTo: from_name.heightAnchor).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: from_image.trailingAnchor, constant: 10).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: to_image.leadingAnchor, constant: -10).isActive = true

        deleteButton.addTarget(self, action: #selector(removeOperation), for: .touchUpInside)

    }

    @objc func removeOperation(sender: UIButton) {
        History.GetHistory().removeOperation(operation: self.operation)
        let parent = self.superview as! UICollectionView
        parent.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    func configure(from model: Operation) {
        self.operation = model
        from_image.image = UIImage(named: model.From.picture)
        from_name.text = model.From.name
        to_image.image = UIImage(named: model.To.picture)
        to_name.text = model.To.name
        textLabel.setTitle("⟶ \(String(model.Value)) ₽ ⟶", for: .normal)
        textLabel.addTarget(self, action: #selector(openEditView), for: .touchUpInside)
    }
    
    @objc func openEditView() {
        print("openEditView")
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SpendingVC") as! SpendingVC
        let vc = SpendingVC()
        vc.from = operation.From.name
        vc.to = operation.To.name
        vc.photoMini.image = operation.Photo
        vc.defaultAmountValue = String(operation.Value)
//        vc.amount.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>) = String(operation.Value)
        vc.fromToText = "⟶ \(String(operation.Value)) ₽ ⟶"
        vc.view.backgroundColor = UIColor.white
        vc.operationID = operation.id

        parentVC?.navigationController?.pushViewController(vc, animated: true)
    }
}


class GridLayout: UICollectionViewFlowLayout {

    let innerSpace: CGFloat = 20.0
    let numberOfCellsOnRow: CGFloat = 1

    override init() {
        super.init()
        self.minimumLineSpacing = innerSpace
        self.minimumInteritemSpacing = innerSpace
        self.scrollDirection = .vertical
    }

    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }

    func itemWidth() -> CGFloat {
        return (collectionView!.frame.size.width/self.numberOfCellsOnRow)-self.innerSpace
    }

    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width:itemWidth(), height: 100)
        }
        get {
            return CGSize(width:itemWidth(),height: 100)
        }
    }

}

