//
//  LoginView.swift
//  CatPower
//
//  Created by Danil on 03/05/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import UIKit

@IBDesignable class LoginView: UIView {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func LoginButton(_ sender: Any) {
    }
    @IBAction func SignUpButton(_ sender: Any) {
    }
    
    var view: UIView!
    var nibName: String = "LoginView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func loadFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func setup() {
        view = loadFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    // this function need for visualize xib in storyboard
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
        view.prepareForInterfaceBuilder()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    
}
