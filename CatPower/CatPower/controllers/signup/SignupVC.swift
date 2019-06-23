//
//  SignupVC.swift
//  CatPower
//
//  Created by Danil on 04/05/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import UIKit
import CoreData

class SignupVC: UIViewController {

    var teamLabel: UILabel = UILabel()
    var usernameTextInput: UITextField = UITextField()
    var emailInput: UITextField = UITextField()
    var passwordInput: UITextField = UITextField()
    var repeatPasswordInput: UITextField = UITextField()
    var BackToLoginButton: UIButton = UIButton()
    var SignupButton: UIButton = UIButton()

    var scrollView: UIScrollView = UIScrollView()

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            self.clearConstraints()
            self.AddConstraintsLandscape(view: scrollView)
        } else {
            self.clearConstraints()
            self.AddConstraintsPortrait(view: scrollView)
        }
    }

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
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true;
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true;
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true;

        self.createItems(view: scrollView)


        //Область прокрутки(до какой ширины и высоты прокручиваться. По умолчанию прокрутки нет и все помещается на экран
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
        if UIDevice.current.orientation.isLandscape {
            self.clearConstraints()
            self.AddConstraintsLandscape(view: scrollView)
        } else {
            self.clearConstraints()
            self.AddConstraintsPortrait(view: scrollView)
        }
    }

    // Отчистка зависимостей между элементами на scrollView (для перестройке при повороте)
    func clearConstraints() {
        self.scrollView.removeConstraints(self.scrollView.constraints)
    }

    private func createItems(view: UIView) {
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
        SignupButton.addTarget(self, action: #selector(GoToMainView), for: .touchUpInside)
        view.addSubview(SignupButton)
    }

    func AddConstraintsPortrait(view: UIView) {
        let margin: CGFloat = 30
        view.addConstraints([
            NSLayoutConstraint(item: teamLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
        ])

        //Добавляем зависимость для верхнего элемента чтобы он был привязан к верхушке scrollView и прокурчивался, а не зависал на верху
        self.teamLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        var previous: Any? = teamLabel
        for elem in [self.usernameTextInput, self.emailInput, self.passwordInput,
                     self.repeatPasswordInput, self.SignupButton, self.BackToLoginButton] {
            view.addConstraints([
                NSLayoutConstraint(item: elem, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: elem, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: elem, attribute: .top, relatedBy: .equal, toItem: previous, attribute: .bottom, multiplier: 1, constant: margin),
            ])
            previous = elem
        }

    }

    func AddConstraintsLandscape(view: UIView) {
        let margin: CGFloat = 30
        view.addConstraints([
            NSLayoutConstraint(item: teamLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
        ])

        //Добавляем зависимость для верхнего элемента чтобы он был привязан к верхушке scrollView и прокурчивался, а не зависал на верху
        self.teamLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        var previous: Any? = teamLabel
        for elem in [self.usernameTextInput, self.emailInput, self.passwordInput,
                     self.repeatPasswordInput] {
            view.addConstraints([
                NSLayoutConstraint(item: elem, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: elem, attribute: .right, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: elem, attribute: .top, relatedBy: .equal, toItem: previous, attribute: .bottom, multiplier: 1, constant: margin),
            ])
            previous = elem
        }
        previous = teamLabel
        for elem in [self.SignupButton, self.BackToLoginButton] {
            view.addConstraints([
                NSLayoutConstraint(item: elem, attribute: .left, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: elem, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: elem, attribute: .top, relatedBy: .equal, toItem: previous, attribute: .bottom, multiplier: 1, constant: margin),
            ])
            previous = elem
        }
    }

    @objc func GoToLogin(sender: UIButton) {
        dismiss(animated: true)
    }

    @objc func GoToMainView(sender: UIButton) {
        
        let username = self.usernameTextInput.text!
        let password = self.passwordInput.text!
        
        if (username.isEmpty ||
            self.emailInput.text!.isEmpty ||
            password.isEmpty) { return }
        if (self.passwordInput.text! != self.repeatPasswordInput.text!) { return }
        
    
        self.saveUserAndToken()
        self.createDefaultCategoriesForUser()
        
        // TODO: validation
        var ok = true
        if ok {
            let vc = storyboard!.instantiateViewController(withIdentifier: "MainVC") as! UIViewController
            let navVC = UINavigationController(rootViewController: vc)
            
            print("token before present mainVC: ", UserDefaults.standard.string(forKey: TOKEN_KEY) ?? "kek")
            present(navVC, animated: true, completion: nil)
        }
    }
    
    private func createDefaultCategoriesForUser() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let allCategories = incomeDefaultCategories + costsDefaultCategories
        let costs = ConvertArraysToEntities(from: allCategories, managedContext: managedContext)

        do {
            try managedContext.save()
        } catch {
            print("Failed save in SinupVC")
        }
    }
    
    private func saveUserAndToken() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "UserModel", in: managedContext)!
        
        let token = UUID().uuidString
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(self.emailInput.text!, forKey: "email")
        user.setValue(self.usernameTextInput.text!, forKey: "username")
        user.setValue(self.passwordInput.text!, forKey: "password")
        user.setValue(token, forKey: "token")

        Auth.setToken(token: token)
        
        do {
            try managedContext.save()
        } catch {
            print("Failed save in SinupVC")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpSegue" {
            // if we need pass data
        }
    }




    // Изменяем область прокрутки при появлении клавиатуры чтобы не закрывало элементы!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotifications()

    }

    //Регистрирует обработчик события появление клавиатуры
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    //Убираем обработчик чтобы не работало в других вьюшках
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let kb_height = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height + kb_height)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
    }

}
