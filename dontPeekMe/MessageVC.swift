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
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UIView!
    
    //segue current user and recipient collection id for FireBase
    var currentUser: String!
    var currentUserName: String!
    var recipient: String!
    var recipientUserName: String!
    
    var textBottomConstraint: NSLayoutConstraint?
    var tableBottomConstraint: NSLayoutConstraint?
    
    private var roundButton = UIButton()
    //private let concurrentDispatchQueue = DispatchQueue(label: "dontPeekMe.recipientNameQueue", attributes: .concurrent)
    var isBlurred = true
    var message: Message!
    var messages = [Message]()
    var db: Firestore!
    
    var conversationRef: DocumentReference? = nil
    
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
        //let uid = recipient!
        
        messageField.layer.cornerRadius = 8
        messageField.clipsToBounds = true
        
        if recipientUserName == nil{
            db.collection("Users").document(recipient).getDocument { (document, error) in
                if let document = document, document.exists{
                    self.title = document["Name"] as! String
                }
            }
        } else {
            title = recipientUserName
        }
        
        currentUser = Auth.auth().currentUser?.uid  //gets current user uid
        
        //reference to the conversation with the recipient
        conversationRef = db
            .collection("Users").document(currentUser)
            .collection("Conversations").document(recipient)
        
        loadData()
        checkForUpdates()
        
        self.view.addConstraint(NSLayoutConstraint(item: textView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: textView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 48))
        
        textBottomConstraint = NSLayoutConstraint(item: textView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(textBottomConstraint!)
        
        tableBottomConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: textView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        self.view.addConstraint(tableBottomConstraint!)
        
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
    //Data from firebase will be fetched and will create instances of Message class
    //Each Message will be stored in the 'message' array
    func loadData() {
        conversationRef!.getDocument {(document, error) in
            if let document = document, document.exists {
                let documentData = document.data()
                let conversation = documentData?["Conversation"] as! NSArray
                if conversation.count > 0{
                    for message in conversation {
                        let map = message as! [String:String]
                        let sender = Array(map.keys)[0]
                        let message = map[sender]
                        self.messages.append(Message(message: message, sender: sender))
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
    }
    
    func checkForUpdates() {
        conversationRef?.addSnapshotListener {
            docSnapShot, error in
            
            guard let snapshot = docSnapShot else {
                print("Error fetching document: \(error!)")
                return
            }
            let documentData = snapshot.data()
            let conversation = documentData?["Conversation"] as! NSArray
            if conversation.count > 0{
                let recentMessage = conversation[conversation.count-1]
                let map = recentMessage as! [String:String]
                let sender = Array(map.keys)[0]
                let message = map[sender]
                self.messages.append(Message(message: message, sender: sender))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //shows the keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            textBottomConstraint?.constant = -keyboardHeight
            self.roundButton.frame.origin.y -= keyboardHeight
            
            UIView.animate(withDuration: 0, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if(self.messages.count > 0){
                    let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            }
            
            print(keyboardHeight)
        }
    }
    
    //hides the keyboard
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            textBottomConstraint?.constant = 0
            self.roundButton.frame.origin.y += keyboardHeight
            
            UIView.animate(withDuration: 0, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if(self.messages.count > 0){
                    let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            }
            
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
            }
        }
        dismiss(animated: true, completion: nil)
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
    
    //scrolls the view to the bottom
    func moveToBottom() {
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    //action for pressing send button
    //will send snapshot of message to Firebase
    @IBAction func sendPressed(_ sender: AnyObject) {
        guard let message = messageField.text else {
            print("There is no message")
            return
        }
        
        conversationRef?.getDocument {(document, error) in
            if let document = document, document.exists {
                let documentData = document.data()
                let conversation = documentData?["Conversation"] as! NSMutableArray
                let newMessage = [self.currentUser:message]
                conversation.add(newMessage)
                
                let recipientRef = self.db
                    .collection("Users").document(self.recipient)
                    .collection("Conversations").document(self.currentUser)
                
                self.messageField.text = ""
                self.conversationRef?.updateData(["Conversation": conversation])
                recipientRef.updateData(["Conversation": conversation])
            }
        }
        dissKeyboard()
        self.moveToBottom()
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



    


