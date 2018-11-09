//
//  UserDefaults+Handlers.swift
//  dontPeekMe
//
//  Created by Neil Warren on 11/8/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import Foundation

extension UserDefaults{
    func setLoggedIn(value: Bool, name: String){
        set(value, forKey: "isLoggedIn")
        set(name, forKey: "userName")
        synchronize()
    }
    
    func isLoggedIn() -> Bool{
        return bool(forKey: "isLoggedIn")
    }
    
    func nameLoggedIn() -> String{
        return string(forKey: "userName") ?? "There was an error!"
    }
}
