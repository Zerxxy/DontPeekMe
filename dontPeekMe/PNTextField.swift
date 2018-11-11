//
//  PNTextField.swift
//  dontPeekMe
//
//  Created by Neil Warren on 11/10/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import UIKit

class PNTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerForNotifications()
    }

    // Will implement phone number formatting later
    private func registerForNotifications() {
        //NotificationCenter.default.addObserver(self, selector: "textDidChange", name: "UITextFieldTextDidChangeNotification", object: self)
    }
    
    deinit {
        //NotificationCenter.removeObserver(self)
    }
}
