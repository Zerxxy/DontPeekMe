//
//  ConversationsTableViewController.swift
//  dontPeekMe
//
//  Created by Neil Warren on 11/6/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import UIKit
import InitialsImageView
import LocalAuthentication
import FirebaseFirestore
import FirebaseAuth

class ConversationsTableViewController: UITableViewController {
    private var roundButton = UIButton()
    private var isBlurred = true
    var conversationNames = [] as [String]
    var testConversation = "This is a test conversation to see if text wrapping works correctly.  The text message preview should be able to show 3 lines of text before cutting off."
        var db: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        //let userid = Auth.auth().currentUser!.uid
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user{
                self.db.collection("Users").document(user.uid).getDocument {(document, error) in
                    if let document = document, document.exists {
                        let documentData = document.data()
                        self.conversationNames = documentData?["Conversations"] as! [String]
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            } else {
                self.signOut()
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleSignOut))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewConversation))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        createFloatingButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if roundButton.superview != nil {
            DispatchQueue.main.async {
                self.roundButton.removeFromSuperview()
                //self.roundButton = nil
            }
        }
    }
    func signOut(){
        UserDefaults.standard.setLoggedIn(value: false, name: "")
        let loginController = storyboard?.instantiateViewController(withIdentifier: "MainNavigation") as! UINavigationController
        present(loginController, animated: true, completion: {
            // Funcitonality to do later?
        })
    }
    
    @objc func handleNewConversation() {
        let newConversationController = NewConversationTableViewController()
        let navController = UINavigationController(rootViewController: newConversationController)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return conversationNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! CustomTableViewCell
        
        // Configure the cell...
        
        let cellName = conversationNames[indexPath.row]
        cell.nameLabel.text = cellName
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user{
                self.db.collection("Users").document(user.uid).collection("Conversations").document(cell.nameLabel.text!).getDocument {(document, error) in
                    if let document = document, document.exists {
                        let documentData = document.data()
                        let conversation = documentData?["Conversation"] as! NSArray
                        let lastMap = conversation.lastObject as! [String:String]
                        let lastMessage = lastMap[Array(lastMap.keys)[0]] as! String
                        cell.messageLabel.text = lastMessage
                    } else {
                        print("Document does not exist")
                    }
                }
            } else {
                self.signOut()
            }
        }
        cell.messageLabel.text = testConversation
        cell.messageLabel.sizeToFit()
        cell.thumbnailImageView.setImageForName(cellName, backgroundColor: nil, circular: true, textAttributes: nil, gradient: true)
        if isBlurred{
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = cell.messageLabel.bounds
            // Unique identifier (tag) for blur effect
            blurView.tag = 99
            cell.messageLabel.addSubview(blurView)
        }
        else{
            if let viewWithTag = cell.messageLabel.viewWithTag(99){
                viewWithTag.removeFromSuperview()
            }
        }

        return cell
    }

    func createFloatingButton() {
        let buttonColor = UIColor(red: 229/255, green: 168/255, blue: 35/255, alpha: 1.0)
        roundButton = UIButton(type: .custom)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        roundButton.backgroundColor = buttonColor
        roundButton.setImage(UIImage(named: "unlock"), for: .normal)
        roundButton.addTarget(self, action: #selector(attemptMessageUnlock), for: UIControl.Event.touchUpInside)
        // Manipulating the UI on the main thread
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(self.roundButton)
                NSLayoutConstraint.activate([
                    keyWindow.trailingAnchor.constraint(equalTo: self.roundButton.trailingAnchor, constant: 20),
                    keyWindow.bottomAnchor.constraint(equalTo: self.roundButton.bottomAnchor, constant: 20),
                    self.roundButton.widthAnchor.constraint(equalToConstant: 50),
                    self.roundButton.heightAnchor.constraint(equalToConstant: 50)])
            }
            //Make the button round
            self.roundButton.layer.cornerRadius = 25
            //Add a black shadow
            self.roundButton.layer.shadowColor = UIColor.black.cgColor
            self.roundButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            self.roundButton.layer.masksToBounds = false
            self.roundButton.layer.shadowRadius = 2.0
            self.roundButton.layer.shadowOpacity = 0.5
            //Could add an animation to the button, may do later
            let pulseAnimation :CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            pulseAnimation.duration = 1.0
            pulseAnimation.repeatCount = .greatestFiniteMagnitude
            pulseAnimation.autoreverses = true
            pulseAnimation.fromValue = 1.0
            pulseAnimation.toValue = 1.05
            self.roundButton.layer.add(pulseAnimation, forKey: "scale")
        }
    }
    
    func deleteFloatingButton(){
        if roundButton.superview != nil {
            DispatchQueue.main.async {
                self.roundButton.removeFromSuperview()
                //self.roundButton = nil
            }
        }
    }
    @objc func attemptMessageUnlock(){
        /*
        let alertController = UIAlertController(title: "Reveal Messages", message: "Incomplete function, will implement later", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
         */
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To prove your identity"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError){
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString){ success, evaluateError in
                if success{
                    //TODO: User authenticated
                    self.unblurMessages()
                } else {
                    //TODO: User not authenticated
                    guard let error = evaluateError else {
                        return
                    }
                    print("Will customize error later")
                }
            }
        }
    }
    
    func unblurMessages(){
        isBlurred = false;
        DispatchQueue.main.async {
            self.deleteFloatingButton()
            self.tableView.reloadData()
        }
        let delayTime = 5
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delayTime)){
            self.isBlurred = true;
            self.createFloatingButton()
            self.tableView.reloadData()
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
