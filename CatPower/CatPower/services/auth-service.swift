//
// Created by Danil on 2019-05-08.
// Copyright (c) 2019 DeadMolesStudio. All rights reserved.
//

import Foundation

let TOKEN_KEY = "TOKEN"

class Auth {


    static func checkAuth() -> Bool {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: TOKEN_KEY) else {
            return false
        }
        // make request for check auth by token
        return true
    }

    // Get user if login success, nil if not
    static func login(username: String, password: String) -> User? {
        // send request for authorized and get user info from
        var user: User = User(username: "test", email: "t@m.r", password: nil, token: "some-auth-token")
        UserDefaults.standard.set(user.token, forKey: TOKEN_KEY)
        return user
    }

    static func logout() -> Bool {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: TOKEN_KEY)
        return true
    }
}
