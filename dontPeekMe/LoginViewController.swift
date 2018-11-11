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

class LoginViewController: UIViewController {

    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override open var shouldAutorotate: Bool{
        return false
    }
    
    @IBAction func attemptLogin(_ sender: Any) {
        let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor.red]
        if let uName = usernameField.text{
            
        }else{
            
        }
    }
    func logIn(uName: String, pWord: String) -> Bool{
        //Attempt to log in, will update with firebase Auth later
        UserDefaults.standard.setLoggedIn(value: true, name: uName)
        return true;
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showConversations"{
            let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor(red: 229/255, green: 168/255, blue: 35/255, alpha: 1.0)]
            var bName = true
            var bWord = true
            let uName = usernameField.text!
            let pWord = passwordField.text!
            if uName.isEmpty{
                var myMutableStringUsername = NSMutableAttributedString()
                myMutableStringUsername = NSMutableAttributedString(string: "Please enter a Username/Email", attributes: attributedStringColor)
                usernameField.attributedPlaceholder = myMutableStringUsername
                bName = false
            }
            if pWord.isEmpty{
                var myMutableStringPassword = NSMutableAttributedString()
                myMutableStringPassword = NSMutableAttributedString(string: "Please enter a Password", attributes: attributedStringColor)
                passwordField.attributedPlaceholder = myMutableStringPassword
                bWord = false
            }
            
            if(!(bWord && bName)){
                return false
            }
            return logIn(uName: uName, pWord: pWord)
        }
        return true
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        let alertController = UIAlertController(title: "Forgot Password", message: "Incomplete function, will implement later", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConversations" {
            let destinationController = segue.destination as! UINavigationController
            let topViewController = destinationController.topViewController as! ConversationsTableViewController
        }
    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
