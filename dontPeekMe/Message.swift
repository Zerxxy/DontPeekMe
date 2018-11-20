//
//  Message.swift
//  dontPeekMe
//
//  Created by Warren Liang on 11/20/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import Foundation

class Message {
    
    private var _message: String!
    private var _sender: String!
    
    var message: String {
        return _message
    }
    
    var sender: String {
        return _sender
    }
    
    init(message: String, sender: String) {
        _message = message
        _sender = sender
    }
}
