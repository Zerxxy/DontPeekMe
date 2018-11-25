//
//  Authorization.swift
//  dontPeekMe
//
//  Created by Neil Warren on 11/19/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

/**
 Provides authorization functions for the DontPeekMe application
 */
class Authorization{
    private static let _instance = Authorization()
    var db: Firestore!
    
    static var instance: Authorization {
        return _instance
    }
    
    /**
     Initializes an instance of Authorization by setting up the Firebase settings
     */
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    /**
     Attempts to login, throws error if found, handled with handleFirebaseError
     
     - Parameter uName: The email of the user
     - Parameter pWord: The password of the user
     - Parameter onComplete: completion block to store either error string
                 or user data
     */
    func login(email: String, password: String, onComplete: Completion?){
        Auth.auth().signIn(withEmail: email,password: password) { (user,error) in
            if error != nil{
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            }
            else{
                onComplete?(nil, user)
            }
        }
    }
    /**
     Attempts to register, throws error if found, handled with handleFirebaseError
     
     - Parameter email: The email of the user
     - Parameter password: The password of the user
     - Parameter phoneNumber: The phone number of the user
     - Parameter onComplete: completion block to store either error string
                 or user data
     */
    func register(email: String, password: String, phoneNumber: String, onComplete: Completion?){
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil{
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            }
            else{
                let uid = authResult?.user.uid
                self.db.collection("Users").document(uid!).setData(["PhoneNumber": phoneNumber, "Email": email, "Conversations": []])
                onComplete?(nil, authResult)
            }
        }
    }
    /**
     Searches database for users with an exact phone number
     
     - Parameter phoneNumber: the phone number to search
     - Parameter onComplete: completion block to store either error string
                 or user data
     */
    func searchUsers(phoneNumber: String, onComplete: Completion?){
        var users = [User]()
        let userSearch = db.collection("Users").whereField("PhoneNumber", isEqualTo: phoneNumber)
        userSearch.getDocuments() { (querySnapshot, err) in
            if ((querySnapshot?.isEmpty)! || err != nil) {
                onComplete?("Phone number does not exist!", nil)
            } else {
                for document in (querySnapshot!.documents){
                    let data = document.data()
                    let uid = document.documentID
                    let u = User(email: data["Email"] as! String, phoneNumber: phoneNumber, uid: uid)
                    users.append(u)
                }
                onComplete?(nil, users as AnyObject)
            }
        }
    }
    
    /**
     Returns all registered users, used when creating new conversations
     
     - Parameter onComplete: completion block to store either error string
                 or user data
     */
    func getAllUsers(onComplete: Completion?){
        var users = [User]()
        let userList = db.collection("Users")
        userList.getDocuments() { (querySnapshot, err) in
            if ((querySnapshot?.isEmpty)! || err != nil) {
                onComplete?("No users found!", nil)
            } else {
                for document in (querySnapshot!.documents){
                    let data = document.data()
                    let uid = document.documentID
                    let u = User(email: data["Email"] as! String, phoneNumber: data["PhoneNumber"] as! String, uid: uid)
                    users.append(u)
                }
                onComplete?(nil, users as AnyObject)
            }
        }
    }
    
    /**
     Handles common Firebase errors, can add more later
     
     - Parameter error: The error passed from Firebase operation
     - Parameter onComplete: completion block to store either error string
                 or user data
     */
    func handleFirebaseError(error: NSError, onComplete: Completion?){
        if let errorCode = AuthErrorCode(rawValue: error.code){
            switch (errorCode){
            case .invalidEmail:
                onComplete?("Invalid email address!", nil)
            case .wrongPassword:
                onComplete?("Invalid password!", nil)
            case .weakPassword:
                onComplete?("Weak password. Please use at least 6 characters.", nil)
            case .userNotFound:
                onComplete?("User not found. Please register a new account.", nil)
            case .emailAlreadyInUse, .accountExistsWithDifferentCredential:
                onComplete?("Could not create account, email already in use!", nil)
            default:
                onComplete?("There was a problem with authentication. Please try again.", nil)
            }
        }
    }
}
