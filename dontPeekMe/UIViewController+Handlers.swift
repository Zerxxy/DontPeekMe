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
    
    func dissmissKeyboard() {
        self.view.endEditing(true)
    }
    
    func setFloatingButton(roundButton: UIButton, bottomConstraint: NSLayoutConstraint){
        let buttonColor = UIColor(red: 229/255, green: 168/255, blue: 35/255, alpha: 1.0)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        roundButton.backgroundColor = buttonColor
        roundButton.setImage(UIImage(named: "unlock"), for: .normal)
        // Manipulating the UI on the main thread
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(roundButton)
                NSLayoutConstraint.activate([
                    keyWindow.trailingAnchor.constraint(equalTo: roundButton.trailingAnchor, constant: 20),
                    bottomConstraint,
                    roundButton.widthAnchor.constraint(equalToConstant: 50),
                    roundButton.heightAnchor.constraint(equalToConstant: 50)])
            }
            //Make the button round
            roundButton.layer.cornerRadius = 25
            //Add a black shadow
            roundButton.layer.shadowColor = UIColor.black.cgColor
            roundButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            roundButton.layer.masksToBounds = false
            roundButton.layer.shadowRadius = 2.0
            roundButton.layer.shadowOpacity = 0.5
            //Could add an animation to the button, may do later
            let pulseAnimation :CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            pulseAnimation.duration = 1.0
            pulseAnimation.repeatCount = .greatestFiniteMagnitude
            pulseAnimation.autoreverses = true
            pulseAnimation.fromValue = 1.0
            pulseAnimation.toValue = 1.05
            roundButton.layer.add(pulseAnimation, forKey: "scale")
        }
    }
}
