//
//  MessageVC.swift
//  dontPeekMe
//
//  Created by Warren Liang on 11/20/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import LocalAuthentication

class MessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UIView!
    
    //segue current user and recipient collection id for FireBase
    var currentUser: String!
    var currentUserName: String!
    var recipient: String!
    var recipientUserName: String!
    
    private var roundButton = UIButton()
    var isBlurred = true
    var message: Message!
    var messages = [Message]()
    var db: Firestore!
    let semaphore = DispatchSemaphore(value: 0)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        let uid = recipient!
        
        DispatchQueue.global().async {
            self.db.collection("Users").document(uid).getDocument {(document, error) in
                if let document = document, document.exists {
                    let documentData = document.data()
                    let name = documentData!["Name"]
                    self.recipientUserName = name as? String
                    self.title = self.recipientUserName
                } else {
                    print("Document does not exist")
                }
                self.semaphore.signal()
            }
        }
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user{
                self.loadData(currentUser: user.uid, recipient: uid)
            }
        }
        //use this when we segue currentUser and recipient data from conversationController
//        if currentUser != "" && currentUser != nil && recipient != "" && recipient != nil {
//            loadData(currentUser: currentUser, recipient: recipient)
//        }
        //loadData(currentUser: "Warren", recipient: "Bob")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissKeyboard))
        view.addGestureRecognizer(tap)
        
        //moves the view of the table to the bottom where the newest messages will be
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.moveToBottom()
        }
    }
    
    //shows the keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            self.textView.frame.origin.y -= keyboardHeight
            self.roundButton.frame.origin.y -= keyboardHeight
            print(keyboardHeight)
        }
    }
    
    //hides the keyboard
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            self.textView.frame.origin.y += keyboardHeight
            self.roundButton.frame.origin.y += keyboardHeight
            print(keyboardHeight)
        }
    }
    
    @objc func dissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        roundButton.addTarget(self, action: #selector(attemptMessageUnlock), for: UIControl.Event.touchUpInside)
        setFloatingButton(roundButton: roundButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        if roundButton.superview != nil {
            DispatchQueue.main.async {
                self.roundButton.removeFromSuperview()
                //self.roundButton = nil
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Message") as? MessagesCell {
            cell.currentUser = self.currentUser
            cell.configCell(message: message, blurred: isBlurred)
            return cell
        } else {
            return MessagesCell()
        }
    }

    //Data from firebase will be fetched and will create instances of Message class
    //Each Message will be stored in the 'message' array
    func loadData(currentUser: String, recipient: String) {
        self.currentUser = currentUser
        self.recipient = recipient
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user{
                self.db.collection("Users").document(user.uid).collection("Conversations").document(recipient).getDocument {(document, error) in
                    if let document = document, document.exists {
                        let documentData = document.data()
                        let conversation = documentData?["Conversation"] as! NSArray
                        for message in conversation{
                            let lastMap = message as! [String:String]
                            let Sender = Array(lastMap.keys)[0]
                            let lastMessage = lastMap[Sender] as! String
                            self.messages.append(Message(message:lastMessage,sender: Sender))
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    } else {
                        // Create the new conversation
                        DispatchQueue.global().async {
                            self.semaphore.wait()
                            let emptyConversations = NSArray()
                            self.db.collection("Users").document(user.uid).getDocument(completion: { (document, error) in
                                if let document = document, document.exists {
                                    let documentData = document.data()
                                    let conversations = documentData?["Conversations"] as! NSMutableArray
                                    conversations.add(recipient)
                                    self.db.collection("Users").document(user.uid).updateData(["Conversations": conversations])
                                }
                            })
                            self.db.collection("Users").document(recipient).getDocument(completion: { (document, error) in
                                if let document = document, document.exists {
                                    let documentData = document.data()
                                    let conversations = documentData?["Conversations"] as! NSMutableArray
                                    conversations.add(user.uid)
                                    self.db.collection("Users").document(recipient).updateData(["Conversations": conversations])
                                }
                            })
                            self.db.collection("Users").document(user.uid).collection("Conversations").document(recipient).setData([
                                "Conversation" : emptyConversations,
                                "Name": self.recipientUserName])
                            self.db.collection("Users").document(recipient).collection("Conversations").document(user.uid).setData([
                                "Conversation" : emptyConversations,
                                "Name": self.currentUserName])
                            print("Document does not exist, creating document now")
                        }
                    }
                }
            } else {
            }
        }
    }
    
    //scrolls the view to the bottom
    func moveToBottom() {
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    //action for pressing send button
    //will send snapshot of message to Firebase
    @IBAction func sendPressed(_ sender: AnyObject) {
        dissKeyboard()
        if (messageField.text != nil && messageField.text != "") {
            Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user{
                    self.db.collection("Users").document(user.uid).collection("Conversations").document(self.recipient).getDocument {(document, error) in
                        if let document = document, document.exists {
                            let documentData = document.data()
                            let conversation = documentData?["Conversation"] as! NSMutableArray
                            let textMessage = self.messageField.text
                            let newMessage = [user.uid: textMessage]
                            conversation.add(newMessage)
                            self.db.collection("Users").document(user.uid).collection("Conversations").document(self.recipient).updateData(["Conversation" : conversation])
                            self.db.collection("Users").document(self.recipient).collection("Conversations").document(user.uid).updateData(["Conversation" : conversation])
                            self.messages.append(Message(message: textMessage!, sender: user.uid))
                            self.messageField.text = ""
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                } else {
                }
            }
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
