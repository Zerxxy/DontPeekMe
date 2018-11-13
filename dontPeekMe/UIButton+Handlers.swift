//
//  UIButton+Handlers.swift
//  dontPeekMe
//
//  Created by Neil Warren on 11/10/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import UIKit

extension UIButton{
    
    func setGradientBackground(topColor: UIColor, bottomColor: UIColor){
        self.layoutIfNeeded()
        let buttonLayer = CAGradientLayer()

        buttonLayer.frame = bounds
        buttonLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        buttonLayer.startPoint = CGPoint(x: 1, y: 0)
        buttonLayer.endPoint = CGPoint(x: 0, y: 1)
        buttonLayer.cornerRadius = 5
        
        layer.cornerRadius = 5
        layer.insertSublayer(buttonLayer, at: 0)
    }
}
