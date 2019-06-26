//
//  LoginVC.swift
//  CatPower
//
//  Created by Danil on 04/05/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import UIKit
import CoreData
import Gloss

class LoginVC: UIViewController {

    var teamLabel: UILabel = UILabel()
    var usernameTextInput: UITextField = UITextField()
    var passwordInput: UITextField = UITextField()
    var LoginButton: UIButton = UIButton()
    var SignupButton: UIButton = UIButton()

    // Изначально хотел сделать contentView внутри ScrollView, но ScrollView перехватывает клики...
    var scrollView: UIScrollView = UIScrollView()

    
    func checkAvailableUsers() {
        print("checkAvailableUsers")
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
        print("end of checkAvailableUsers")
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

        //Область прокрутки(до какой ширины и высоты прокручиваться. По умолчанию прокрутки нет и все помещается на экран
//        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width+3000, height: self.scrollView.frame.size.height+3400)
        // Create UI elements
        createItems(view: scrollView)
        // Add constraints to elements
        AddConstraints(view: scrollView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
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

        self.passwordInput = CreateTextField(placeholder: "password")
        passwordInput.isSecureTextEntry = true
        view.addSubview(passwordInput)

        self.LoginButton = CreateDefaultButton(text: "Login")
        LoginButton.addTarget(self, action: #selector(GoToMainView), for: .touchUpInside)
        view.addSubview(LoginButton)

        self.SignupButton = CreateDefaultButton(text: "SignUp")
        SignupButton.addTarget(self, action: #selector(GoToSignUpView), for: .touchUpInside)
        view.addSubview(SignupButton)

    }

    func AddConstraints(view: UIView) {
        let margin: CGFloat = 30
        view.addConstraints([
            NSLayoutConstraint(item: teamLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
        ])

        //Добавляем зависимость для верхнего элемента чтобы он был привязан к верхушке scrollView и прокурчивался, а не зависал на верху
        self.teamLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

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
        var username: String = ""
        var password: String = ""

        //validating fields
        if self.usernameTextInput.text == nil || self.usernameTextInput.text?.isEmpty == true{
            self.usernameTextInput.layer.borderColor = UIColor.red.cgColor
            self.usernameTextInput.layer.borderWidth = 2
            self.usernameTextInput.placeholder = "Input username!"
        } else {
            username = self.usernameTextInput.text!
        }
        if self.passwordInput.text == nil || self.passwordInput.text?.isEmpty == true {
            self.passwordInput.layer.borderColor = UIColor.red.cgColor
            self.passwordInput.layer.borderWidth = 2
            self.passwordInput.placeholder = "Input password!"
        } else {
            password = self.passwordInput.text!
        }

        if username.isEmpty || password.isEmpty {
            return
        }

        let user = Auth.login(username: username, password: password)
        print("try to login", user)
        if user != nil {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! ViewController
            vc.user = user!
            let navVC = UINavigationController(rootViewController: vc)
            doTestRequest()
            present(navVC, animated: true, completion: nil)
        }
    }
    
    func doTestRequest() {
        print("doTestRequest()")
        let sourceURL = "http://127.0.0.1:5000/api/info"
        
        struct SimpleModel: JSONDecodable {
            let authors: [String]
        
            init(authors: [String]?) {
                self.authors = authors ?? [String]()
            }
        
            init?(json: JSON) {
                guard let authors: [String] = "authors" <~~ json else {
                    return nil
                }
                
                self.authors = authors
            }
        }
    
    
        var data: [SimpleModel] = []
        let session = URLSession(configuration: URLSessionConfiguration.default)
    
        
        session.dataTask(with: URL(string: sourceURL)!) { [weak self] data, resp, err in
            guard err == nil else {
                print("error getting file: \(err!)")
                return
            }
            
            guard let data = data, let _models = try? JSONSerialization.jsonObject(with: data, options: .allowFragments), let models = _models as? [[String: Any]] else {
                return
            }
            
            var dataKek = models.map { m in
                return SimpleModel(authors: m["authors"] as? [String])
            }
            //            guard let data = data, let models = [SimpleModel].from(data: data) else {
            //                return
            //            }
            //
            //            self?.data = models
            for name in dataKek {
                print("PP", name.authors[0])
            }
            DispatchQueue.main.async {
    //            self?.tableView.reloadData()
            }
        }.resume()
        
    }

    @objc func GoToSignUpView(sender: UIButton) {
        performSegue(withIdentifier: "SignUpSegue", sender: self)
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
