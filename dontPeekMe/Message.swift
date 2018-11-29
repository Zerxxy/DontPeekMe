//
//  Message.swift
//  dontPeekMe
//
//  Created by Warren Liang on 11/20/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Message {
    var message: String
    var sender: String
    
    init(message: String!, sender: String!) {
        self.message = message
        self.sender = sender
    }
}
