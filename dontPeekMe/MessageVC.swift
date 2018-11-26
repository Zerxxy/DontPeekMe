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

class MessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UIView!
    
    //segue current user and recipient collection id for FireBase
    var currentUser: String!
    var recipient: String!
    
    var message: Message!
    var messages = [Message]()
    var db: Firestore!
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
        //use this when we segue currentUser and recipient data from conversationController
//        if currentUser != "" && currentUser != nil && recipient != "" && recipient != nil {
//            loadData(currentUser: currentUser, recipient: recipient)
//        }
        loadData(currentUser: "Warren", recipient: "Bob")
        
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
            print(keyboardHeight)
        }
    }
    
    //hides the keyboard
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            self.textView.frame.origin.y += keyboardHeight
            print(keyboardHeight)
        }
    }
    
    @objc func dissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
            cell.configCell(message: message)
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
        let messages = [] as! NSMutableArray
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
                            messages.add(Message(message:lastMessage,sender: Sender))
                        }
                        
                    } else {
                        print("Document does not exist")
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
        
        //this will send message into the database
        if (messageField.text != nil && messageField.text != "") {
            
        }
    }
}
