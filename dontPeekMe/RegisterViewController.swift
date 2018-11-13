//
//  RegisterViewController.swift
//  dontPeekMe
//
//  Created by Neil Warren on 11/10/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var registerUsernameField: UITextField!
    @IBOutlet weak var registerPasswordField: UITextField!
    @IBOutlet weak var repeatedPasswordField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        // Set up all the colors
        let bgTopColor = UIColor(red: 0, green: 85/255, blue: 162/255, alpha: 0.75)
        let bgBottomColor = UIColor(red: 0, green: 85/255, blue: 162/255, alpha: 1.0)
        
        let buttonTopColor = UIColor(red: 229/255, green: 168/255, blue: 35/255, alpha: 0.75)
        let buttonBottomColor = UIColor(red: 229/255, green: 168/255, blue: 35/255, alpha: 1.0)
        
        let textColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1.0)
        
        // Set the background color
        setGradientBackground(topColor: bgTopColor, bottomColor: bgBottomColor)
        
        // Set the button color
        registerButton.setGradientBackground(topColor: buttonTopColor, bottomColor: buttonBottomColor)
        
        // Set the custom text fields
        registerUsernameField.addUnderLine(lineColor: textColor)
        registerPasswordField.addUnderLine(lineColor: textColor)
        repeatedPasswordField.addUnderLine(lineColor: textColor)
        phoneNumberField.addUnderLine(lineColor: textColor)
        
        self.registerUsernameField.delegate = self
        self.registerPasswordField.delegate = self
        self.repeatedPasswordField.delegate = self
        
        phoneNumberField.keyboardType = UIKeyboardType.numberPad
        
        // Set up navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let backButton = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = textColor
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override open var shouldAutorotate: Bool{
        return false
    }
    
    @IBAction func attemptRegister(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.registerUsernameField.text!, password: self.registerPasswordField.text!) { (authResult,error) in
            var uid = authResult?.user.uid
            self.db.collection("Users").document(uid!).setData(["PhoneNumber": self.phoneNumberField.text!, "Conversations": []])
        }
        let alertController = UIAlertController(title: "Register", message: "Registered!", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
