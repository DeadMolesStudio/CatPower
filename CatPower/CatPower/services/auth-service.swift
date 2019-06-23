//
// Created by Danil on 2019-05-08.
// Copyright (c) 2019 DeadMolesStudio. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let TOKEN_KEY = "TOKEN"
let CURRENT_USER_ENTITY_KEY = "CURRENT_USER_ENTITY_KEY"

class Auth {
    
    static func getCurrentUserEntity() -> NSManagedObject? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let currentUserToken = UserDefaults.standard.string(forKey: TOKEN_KEY) ?? "ANON"

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserModel")
        fetchRequest.predicate = NSPredicate(format: "token=%@", currentUserToken)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                return data
            }
        } catch {
            print("Failed")
        }
        return nil
    }
    
    static private func retrieveUserFromCoreData(username: String, password: String) -> User? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserModel")
        fetchRequest.predicate = NSPredicate(format: "username=%@", username)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let dataPass = data.value(forKey: "password") as! String

                if (dataPass == password) {
                    let user = User(
                        username: username,
                        email: data.value(forKey: "email") as! String?,
                        password: password,
                        token: data.value(forKey: "token") as! String?
                    )
                    
                    
                    return user
                }
            }
        } catch {
            print("Failed")
        }
        return nil
    }

    static func checkAuth() -> Bool {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: TOKEN_KEY) else {
            print("token not found checkAuth -> bool")
            return false
        }
        print(token)
        // make request for check auth by token
        // backend.isTokenValid(user: user)
        
        return true
    }

    static func checkAuth(username: String, password: String) -> User? {
//        let defaults = UserDefaults.standard
//        guard let token = defaults.string(forKey: TOKEN_KEY) else {
//            return nil
//        }
        let user = retrieveUserFromCoreData(username: username, password: password)
        // make request for check auth by token
        // backend.isTokenValid(user: user)
        return user
    }
    
    static func setToken(token: String) {
        print("token set: ", token)
        UserDefaults.standard.set(token, forKey: TOKEN_KEY)
//        print("token test1: ", UserDefaults.value(forKey: TOKEN_KEY) as? String ?? "kek")
//        print("token test2: ", UserDefaults.standard.string(forKey: TOKEN_KEY) ?? "kek")
    }

    // Get user if login success, nil if not
    static func login(username: String, password: String) -> User? {
        let user = checkAuth(username: username, password: password)
        if user == nil { return nil }
        // send request for authorized and get user info from
        UserDefaults.standard.set(user!.token, forKey: TOKEN_KEY)

        return user
    }

    static func logout() -> Bool {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: TOKEN_KEY)
        return true
    }
}
