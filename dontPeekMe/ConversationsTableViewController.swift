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
    var currentUserName: String!
    var recipient: String?
    var recipientUserName: String?
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
                        self.currentUserName = documentData?["Name"] as? String
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
        roundButton.addTarget(self, action: #selector(attemptMessageUnlock), for: UIControl.Event.touchUpInside)
        setFloatingButton(roundButton: roundButton)
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
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print ("Error signing out: \(error)")
        }
        
        let loginController = storyboard?.instantiateViewController(withIdentifier: "MainNavigation") as! UINavigationController
        present(loginController, animated: true, completion: {
            // Funcitonality to do later?
        })
    }
    
    @objc func handleNewConversation() {
        let newConversationController = NewConversationTableViewController()
        newConversationController.conversationViewController = self
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
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user{
                self.db.collection("Users").document(user.uid).collection("Conversations").document(cellName).getDocument {(document, error) in
                    if let document = document, document.exists {
                        let documentData = document.data()
                        let conversation = documentData?["Conversation"] as! NSArray
                        let lastMap = conversation.lastObject as! [String:String]
                        let lastMessage = lastMap[Array(lastMap.keys)[0]] as! String
                        cell.messageLabel.text = lastMessage
                        let name = documentData?["Name"] as! String
                        cell.nameLabel.text = name
                        cell.thumbnailImageView.setImageForName(name, backgroundColor: nil, circular: true, textAttributes: nil, gradient: true)                    } else {
                        print("Document does not exist")
                    }
                }
            } else {
                self.signOut()
            }
        }

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.recipient = conversationNames[indexPath.row]
        performSegue(withIdentifier: "showMessages", sender: self)
    }
    
    /**
     Prepares for cell selection, passes recipient UID
     - Parameter segue: The segue object containing information about
                 the view controllers involved in the segue.
     - Parameter sender: The object that initiated the segue. You might
                 use this parameter to perform different actions based
                 on which control (or other object) initiated the segue.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showMessages"){
            let messageVC = segue.destination as! MessageVC
            messageVC.recipient = self.recipient
            messageVC.currentUserName = self.currentUserName
            messageVC.recipientUserName = self.recipientUserName
        }
    }

    @objc func attemptMessageUnlock(){
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
                    guard evaluateError != nil else {
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
            self.roundButton.isHidden = true
            self.tableView.reloadData()
        }
        let delayTime = 5
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delayTime)){
            self.isBlurred = true;
            self.roundButton.isHidden = false
            self.tableView.reloadData()
        }
    }
}
