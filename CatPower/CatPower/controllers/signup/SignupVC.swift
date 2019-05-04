//
//  SignupVC.swift
//  CatPower
//
//  Created by Danil on 04/05/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    var teamLabel: UILabel
    var usernameTextInput: UITextField
    var emailInput: UITextField
    var passwordInput: UITextField
    var repeatPasswordInput: UITextField
    var BackToLoginButton: UIButton
    var SignupButton: UIButton


    required init?(coder aDecoder: NSCoder) {
        self.teamLabel = UILabel()
        self.usernameTextInput = UITextField()
        self.passwordInput = UITextField()
        self.repeatPasswordInput = UITextField()
        self.BackToLoginButton = UIButton()
        self.SignupButton = UIButton()
        self.emailInput = UITextField()
        super.init(coder: aDecoder)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            self.view.removeConstraints(view.constraints)
            self.AddConstraintsLandscape()
        } else {
            self.view.removeConstraints(view.constraints)
            self.AddConstraintsPortrait()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Create UI elements
        createItems()
        // Add constraints to elements
        if UIDevice.current.orientation.isLandscape {
            self.view.removeConstraints(view.constraints)
            self.AddConstraintsLandscape()
        } else {
            self.view.removeConstraints(view.constraints)
            self.AddConstraintsPortrait()
        }
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

        self.emailInput = CreateTextField(placeholder: "email")
        view.addSubview(emailInput)

        self.passwordInput = CreateTextField(placeholder: "password")
        passwordInput.isSecureTextEntry = true
        view.addSubview(passwordInput)

        self.repeatPasswordInput = CreateTextField(placeholder: "repeat password")
        repeatPasswordInput.isSecureTextEntry = true
        view.addSubview(repeatPasswordInput)

        self.BackToLoginButton = CreateDefaultButton(text: "BackToLogin")
        BackToLoginButton.addTarget(self, action: #selector(GoToLogin), for: .touchUpInside)
        view.addSubview(BackToLoginButton)

        self.SignupButton = CreateDefaultButton(text: "SignUp")
        SignupButton.addTarget(self, action: #selector(GoToManView), for: .allTouchEvents)
        view.addSubview(SignupButton)

    }

    func AddConstraintsPortrait() {
        let margin: CGFloat = 30
        self.view.addConstraints([
            NSLayoutConstraint(item: teamLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: margin),
            NSLayoutConstraint(item: teamLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
        ])
        var previous: Any? = teamLabel
        for elem in [self.usernameTextInput, self.emailInput, self.passwordInput,
                     self.repeatPasswordInput, self.SignupButton, self.BackToLoginButton] {
            self.view.addConstraints([
                NSLayoutConstraint(item: elem, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: elem, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: elem, attribute: .top, relatedBy: .equal, toItem: previous, attribute: .bottom, multiplier: 1, constant: margin),
            ])
            previous = elem
        }
    }

    func AddConstraintsLandscape() {
        let margin: CGFloat = 30
        self.view.addConstraints([
            NSLayoutConstraint(item: teamLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: margin),
            NSLayoutConstraint(item: teamLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
        ])
        var previous: Any? = teamLabel
        for elem in [self.usernameTextInput, self.emailInput, self.passwordInput,
                     self.repeatPasswordInput] {
            self.view.addConstraints([
                NSLayoutConstraint(item: elem, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: elem, attribute: .right, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: elem, attribute: .top, relatedBy: .equal, toItem: previous, attribute: .bottom, multiplier: 1, constant: margin),
            ])
            previous = elem
        }
        previous = teamLabel
        for elem in [self.SignupButton, self.BackToLoginButton] {
            self.view.addConstraints([
                NSLayoutConstraint(item: elem, attribute: .left, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: elem, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: elem, attribute: .top, relatedBy: .equal, toItem: previous, attribute: .bottom, multiplier: 1, constant: margin),
            ])
            previous = elem
        }
    }

    @objc func GoToLogin(sender: UIButton) {
        dismiss(animated: true)
    }

    @objc func GoToManView(sender: UIButton) {
        // TODO: validation
        var ok = true
        if ok {
            let vc = storyboard?.instantiateViewController(withIdentifier: "RootVC") as! UIViewController
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true, completion: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpSegue" {
            // if we need pass data
        }
    }

}
