//
//  user.swift
//  CatPower
//
//  Created by Danil on 04/05/2019.
//  Copyright © 2019 DeadMolesStudio. All rights reserved.
//

import Foundation

class User {
    var username: String?
    var email: String?
    var password: String?
    var token: String?

    init() {
        self.username = ""
        self.email = ""
        self.password = ""
        self.token = ""
    }

    init(username: String?, email: String?, password: String?, token: String?) {
        self.username = username
        self.email = email
        self.password = password
        self.token = token
    }
}
