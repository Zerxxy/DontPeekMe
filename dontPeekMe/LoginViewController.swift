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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isLoggedIn(){
            perform(#selector(showConversationController), with: nil, afterDelay: 0.01)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        // Set the background color and login button color
        let bgLayer = CAGradientLayer()
        let buttonLayer = CAGradientLayer()
        
        
        let bgTopColor = UIColor(red: 0, green: 85/255, blue: 162/255, alpha: 0.75)
        let bgBottomColor = UIColor(red: 0, green: 85/255, blue: 162/255, alpha: 1.0)
        let buttonTopColor = UIColor(red: 229/255, green: 168/255, blue: 35/255, alpha: 0.75)
        let buttonBottomColor = UIColor(red: 229/255, green: 168/255, blue: 35/255, alpha: 1.0)
        
        bgLayer.frame = view.bounds
        bgLayer.colors = [bgTopColor.cgColor, bgBottomColor.cgColor]
        bgLayer.startPoint = CGPoint(x:1, y:0)
        bgLayer.endPoint = CGPoint(x:0, y:1)
        
        buttonLayer.frame = loginButton.bounds
        buttonLayer.colors = [buttonTopColor.cgColor, buttonBottomColor.cgColor]
        buttonLayer.startPoint = CGPoint(x: 1, y: 0)
        buttonLayer.endPoint = CGPoint(x: 0, y: 1)
        buttonLayer.cornerRadius = 5
        
        view.layer.insertSublayer(bgLayer, at: 0)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.insertSublayer(buttonLayer, at: 0)
        
    }
    
    func logIn(uName: String, pWord: String) -> Bool{
        //Attempt to log in, will update with firebase Auth later
        UserDefaults.standard.setLoggedIn(value: true, name: uName)
        return true;
    }
    
    fileprivate func isLoggedIn() -> Bool{
        return UserDefaults.standard.isLoggedIn()
    }
    
    @objc func showConversationController() {
        let conversationController = storyboard?.instantiateViewController(withIdentifier: "Navigation") as! UINavigationController
        present(conversationController, animated: true, completion: {
            //Functionality to do later?
        })
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showConversations"{
            let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor.red]
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
