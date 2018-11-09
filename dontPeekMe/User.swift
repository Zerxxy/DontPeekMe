//
//  User.swift
//  dontPeekMe
//
//  Created by Neil Warren on 11/7/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import Foundation

class User {
    var name = ""
    var image:String?
    
    init(name: String, image: String?) {
        self.name = name
        self.image = image
    }
}
