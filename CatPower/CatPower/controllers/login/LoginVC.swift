//
//  LoginVC.swift
//  CatPower
//
//  Created by Danil on 04/05/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    var teamLabel: UILabel
    var usernameTextInput: UITextField
    var passwordInput: UITextField
    var LoginButton: UIButton
    var SignupButton: UIButton


    required init?(coder aDecoder: NSCoder) {
        self.teamLabel = UILabel()
        self.usernameTextInput = UITextField()
        self.passwordInput = UITextField()
        self.LoginButton = UIButton()
        self.SignupButton = UIButton()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Create UI elements
        createItems()
        // Add constraints to elements
        AddConstraints()
    }

    private func createItems() {
        // Create items
        self.teamLabel = {
            let label = UILabel()
            label.text = "DeadMolesStudio"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        view.addSubview(teamLabel)

        self.usernameTextInput = CreateTextField(placeholder: "username")
        view.addSubview(usernameTextInput)

        self.passwordInput = CreateTextField(placeholder: "password")
        passwordInput.isSecureTextEntry = true
        view.addSubview(passwordInput)

        self.LoginButton = CreateDefaultButton(text: "Login")
        LoginButton.addTarget(self, action: #selector(GoToMainView), for: .touchUpInside)
        view.addSubview(LoginButton)

        self.SignupButton = CreateDefaultButton(text: "SignUp")
        SignupButton.addTarget(self, action: #selector(GoToSignUpView), for: .allTouchEvents)
        view.addSubview(SignupButton)

    }

    func AddConstraints() {
        let margin: CGFloat = 30
        self.view.addConstraints([
            NSLayoutConstraint(item: teamLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: margin),
            NSLayoutConstraint(item: teamLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
        ])
        var previous: Any? = teamLabel
        for elem in [self.usernameTextInput, self.passwordInput, self.LoginButton, self.SignupButton] {
            self.view.addConstraints([
                NSLayoutConstraint(item: elem, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: elem, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: elem, attribute: .top, relatedBy: .equal, toItem: previous, attribute: .bottom, multiplier: 1, constant: margin),
            ])
            previous = elem
        }
    }

    @objc func GoToMainView(sender: UIButton) {
        // TODO: login API
        var login = true
        if login {
            let vc = storyboard?.instantiateViewController(withIdentifier: "RootVC") as! UIViewController
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true, completion: nil)
        }
    }

    @objc func GoToSignUpView(sender: UIButton) {
        performSegue(withIdentifier: "SignUpSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpSegue" {
            // if we need pass data
        }
    }
}
