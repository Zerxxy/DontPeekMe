//
//  LoginViewController.swift
//  dontPeekMe
//
//  Created by Neil Warren on 11/8/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//
//  This is the initial view, if the user is already logged in
//  the view will change to the conversations

import UIKit
import FirebaseAuth
import Crashlytics
class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    var isLoggedIn = false
    
    typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(view.accessibilityIdentifier)
        // Set the background color and login button color
        let bgTopColor = UIColor(red: 0, green: 85/255, blue: 162/255, alpha: 0.75)
        let bgBottomColor = UIColor(red: 0, green: 85/255, blue: 162/255, alpha: 1.0)
        setGradientBackground(topColor: bgTopColor, bottomColor: bgBottomColor)
        
        let buttonTopColor = UIColor(red: 229/255, green: 168/255, blue: 35/255, alpha: 0.75)
        let buttonBottomColor = UIColor(red: 229/255, green: 168/255, blue: 35/255, alpha: 1.0)
        loginButton.setGradientBackground(topColor: buttonTopColor, bottomColor: buttonBottomColor)
        
        // Set up the username/password fields
        let lineColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1.0)
        usernameField.addUnderLine(lineColor: lineColor)
        passwordField.addUnderLine(lineColor: lineColor)
        
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameField.text = ""
        passwordField.text = ""
    }
    override open var shouldAutorotate: Bool{
        return false
    }
    
    @IBAction func attemptLogin(_ sender: Any) {
        let uName = usernameField.text!
        let pWord = passwordField.text!
        Authorization.instance.login(email: uName, password: pWord) { (errMsg, data) in
            guard errMsg == nil else{
                let alert = UIAlertController(title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            UserDefaults.standard.setLoggedIn(value: true, name: uName)
            self.performSegue(withIdentifier: "showConversations", sender: self)
        }
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        Crashlytics.sharedInstance().crash()
        //let alertController = UIAlertController(title: "Forgot Password", message: "Incomplete function, will implement later", preferredStyle: UIAlertController.Style.alert)
        //alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        //present(alertController, animated: true, completion: nil)
    }
}
