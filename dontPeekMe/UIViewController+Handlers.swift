//
//  UIViewController+Handlers.swift
//  dontPeekMe
//
//  Created by Neil Warren on 11/10/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func setGradientBackground(topColor: UIColor, bottomColor: UIColor){
        let bgLayer = CAGradientLayer()
        
        bgLayer.frame = view.bounds
        bgLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        bgLayer.startPoint = CGPoint(x:1, y:0)
        bgLayer.endPoint = CGPoint(x:0, y:1)
        view.layer.insertSublayer(bgLayer, at: 0)
    }
}
