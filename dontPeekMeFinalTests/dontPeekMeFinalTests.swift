//
//  dontPeekMeBlackBoxTests.swift
//  dontPeekMeBlackBoxTests
//
//  Created by Addison Kauzer on 11/28/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import XCTest
@testable import dontPeekMe
class dontPeekMeFinalTests: XCTestCase {
    var AuthorizationTest: Authorization!
    var MessageVCTest: MessageVC!
    var ConversationsTableTest: ConversationsTableViewController!
    var LoginViewTest: LoginViewController!
    override func setUp() {
        LoginViewTest = LoginViewController()
        MessageVCTest = MessageVC()
        AuthorizationTest = Authorization()
        ConversationsTableTest = ConversationsTableViewController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        AuthorizationTest = nil
        MessageVCTest = nil
        ConversationsTableTest = nil
        LoginViewTest = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLogin() {
        AuthorizationTest.login(email: "t@t.com", password: "aaaaaa") { (errMsg, data) in
            guard errMsg == nil else{
                XCTFail()
                return
            }
            XCTAssertTrue(true)
        }
        
    }
    
    func testRegister() {
        AuthorizationTest.register(fullName: "Test", email: "TestTestTest@test.com", password: "aaaaaa", phoneNumber: "17078856458") { (errMsg, data) in
            guard errMsg == nil else{
                XCTFail()
                return
            }
            XCTAssertTrue(true)
        }
    }
    func testGetAllUsers() {
        AuthorizationTest.getAllUsers() { (errMsg, data) in
            guard errMsg == nil else{
                XCTFail()
                return
            }
            XCTAssertTrue(true)
        }
    }
    
    func testMessageUnlock() {
        do{
            MessageVCTest.attemptMessageUnlock()
        } catch is Error {
            XCTFail()
        }
        XCTAssertTrue(true)
    }
    
    func testMessageUnblur() {
        MessageVCTest.unblurMessages()
        if(MessageVCTest.isBlurred){
            XCTFail()
        }
        XCTAssertTrue(true)
    }
    
    func testConversationUnlock() {
        do {
            try ConversationsTableTest.attemptMessageUnlock()
        } catch is Error {
            XCTFail()
        }
        XCTAssertTrue(true)
    }
    
    func testConversationUnblur() {
        do {
            try ConversationsTableTest.unblurMessages()
        } catch is Error {
            XCTFail()
        }
        XCTAssertTrue(true)
    }
    func testLoginViewTest() {
        do {
            try LoginViewTest.loadView()
        } catch is Error {
            XCTFail()
        }
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLoginButton() {
        do {
            let buton = LoginViewTest.loginButton
        } catch is Error {
            XCTFail()
        }
        XCTAssertTrue(true)
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testForgotPasswordButton() {
        do {
            let button = LoginViewTest.forgotPasswordButton
        } catch is Error {
            XCTFail()
        }
        XCTAssertTrue(true)        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testRegisterButton() {
        do {
            let button = try LoginViewTest.signUpButton
        } catch is Error {
            XCTFail()
        }
        XCTAssertTrue(true)
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSignOutButton() {
        do {
            let name = ConversationsTableTest.currentUserName
        } catch is Error {
            XCTFail()
        }
        XCTAssertTrue(true)
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testInitialConversations() {
        XCTAssertTrue(ConversationsTableTest.conversationNames == [])
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testShowKeyboard() {
        do {
            let button = MessageVCTest.sendButton
        } catch is Error {
            XCTFail()
        }
        XCTAssertTrue(true)
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testHideKeyboard() {
        do {
            let button = MessageVCTest.editButtonItem
        } catch is Error {
            XCTFail()
        }
        XCTAssertTrue(true)
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }}

