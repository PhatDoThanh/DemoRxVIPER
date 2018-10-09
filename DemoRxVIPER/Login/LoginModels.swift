//
//  LoginModels.swift
//  DemoRxVIPER
//
//  Created by PhatDT3 on 10/9/18.
//  Copyright © 2018 PhatDT3. All rights reserved.
//

import Foundation

class UserInfo {
    
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

class LoginStatus {
    var isSuccess: Bool
    var errorMessage: String
    
    init (isSuccess: Bool = false, errorMessage: String = "") {
        self.isSuccess = isSuccess
        self.errorMessage = errorMessage
    }
}
