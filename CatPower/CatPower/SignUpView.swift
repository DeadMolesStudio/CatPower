//
//  SignUpView.swift
//  CatPower
//
//  Created by Danil on 04/05/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import UIKit

//@IBDesignable
class SignUpView: UIView {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBAction func signUpButton(_ sender: Any) {
    }
    var view: UIView!
    var nibName: String = "SignUpView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func loadFromNib() -> UIView {
        let bundle = Bundle(for: SignUpView.self)
//        bundle.loadNibNamed(self.nibName, owner: self, options: nil)
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func setup() {
        self.view = loadFromNib()
        self.view.frame = bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    // TODO: some wierd problem with storyboard if using visualization of two xibs
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        self.setup()
//        self.view.prepareForInterfaceBuilder()
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
}
