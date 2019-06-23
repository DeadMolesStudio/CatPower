//
//  fromToView.swift
//  CatPower
//
//  Created by Кирилл Гаджиев on 14/06/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import Foundation
import UIKit

class FromToView: UIView {
    
    var operation = Operation()
    var from_image = HistoryCellImage()
    var to_image = HistoryCellImage()
    var textLabel = HistoryCellLabel()
    var from_name = HistoryCellLabel()
    var to_name = HistoryCellLabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init here")
        self.addSubview(from_image)
        self.addSubview(to_image)
        self.addSubview(textLabel)
        self.addSubview(from_name)
        self.addSubview(to_name)

        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        from_image.topAnchor.constraint(equalTo:self.topAnchor, constant: 10).isActive = true
        //        from_image.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        from_image.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:10).isActive = true
        from_image.widthAnchor.constraint(equalToConstant:64).isActive = true
        from_image.heightAnchor.constraint(equalToConstant:64).isActive = true
        
        from_name.widthAnchor.constraint(equalTo: from_image.widthAnchor).isActive = true
        from_name.topAnchor.constraint(equalTo: from_image.bottomAnchor, constant: 10).isActive = true
        from_name.leadingAnchor.constraint(equalTo: from_image.leadingAnchor).isActive = true
        
        to_image.topAnchor.constraint(equalTo:self.topAnchor, constant: 10).isActive = true
        to_image.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-10).isActive = true
        to_image.widthAnchor.constraint(equalToConstant:64).isActive = true
        to_image.heightAnchor.constraint(equalToConstant:64).isActive = true
        
        to_name.widthAnchor.constraint(equalTo: to_image.widthAnchor).isActive = true
        to_name.topAnchor.constraint(equalTo: to_image.bottomAnchor, constant: 10).isActive = true
        to_name.leadingAnchor.constraint(equalTo: to_image.leadingAnchor).isActive = true
        
        
        textLabel.centerYAnchor.constraint(equalTo: from_image.centerYAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalTo: from_image.heightAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: from_image.trailingAnchor, constant: 10).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: to_image.leadingAnchor, constant: -10).isActive = true
        
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
//        textLabel.text = "⟶ ? ⟶"
    }
}

