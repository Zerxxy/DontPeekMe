//
//  User.swift
//  dontPeekMe
//
//  Created by Neil Warren on 11/7/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import Foundation

class User {
    var email: String
    var phoneNumber: String
    var uid: String
    
    init(email: String, phoneNumber: String, uid: String) {
        self.email = email
        self.phoneNumber = phoneNumber
        self.uid = uid
    }
}
