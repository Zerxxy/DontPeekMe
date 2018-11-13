//
//  UITextField+Handlers.swift
//  dontPeekMe
//
//  Created by Neil Warren on 11/10/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import UIKit

extension UITextField{
    
    func addUnderLine(lineColor: UIColor){
        self.layoutIfNeeded()
        if let placeholderStr = self.attributedPlaceholder?.string{
            let placeholderAttributes = [NSAttributedString.Key.foregroundColor: lineColor]
            self.attributedPlaceholder = NSAttributedString(string: placeholderStr, attributes: placeholderAttributes)
            self.backgroundColor = .clear
            self.borderStyle = .none
            let borderLine = UIView()
            borderLine.frame.size = CGSize(width: self.frame.size.width, height: 1)
            borderLine.frame.origin = CGPoint(x: 0, y: self.frame.height - borderLine.frame.height)
            borderLine.backgroundColor = lineColor
            self.addSubview(borderLine)
        }
    }
}
