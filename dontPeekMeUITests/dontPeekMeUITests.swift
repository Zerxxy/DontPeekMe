//
//  dontPeekMeUITests.swift
//  dontPeekMeUITests
//
//  Created by Neil Warren on 12/3/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import XCTest

class dontPeekMeUITests: XCTestCase {
    var app: XCUIApplication!
    let exists = NSPredicate(format: "exists == 1")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
    }

    func testALoginToRegister() {
        
        app/*@START_MENU_TOKEN@*/.buttons["signUpButton"]/*[[".buttons[\"SIGN UP\"]",".buttons[\"signUpButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.navigationBars["dontPeekMe.RegisterView"].exists)
        app.navigationBars["dontPeekMe.RegisterView"].buttons["close"].tap()
        XCTAssert(app.navigationBars["dontPeekMe.LoginView"].exists)
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testBRegisterNewAccount() {
        // Click the sign up button
        app/*@START_MENU_TOKEN@*/.buttons["signUpButton"]/*[[".buttons[\"SIGN UP\"]",".buttons[\"signUpButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.navigationBars["dontPeekMe.RegisterView"].exists)
        
        // Fill in full name field
        let nameTextField = app.textFields["fullNameField"]
        nameTextField.tap()
        nameTextField.typeText("test")
        
        // Fill in username field
        let registerUsernameField = app.textFields["registerUsernameField"]
        registerUsernameField.tap()
        registerUsernameField.typeText("test123@test.com")
        
        // Fill in password field
        let registerPasswordField = app.secureTextFields["registerPasswordField"]
        registerPasswordField.tap()
        registerPasswordField.typeText("aaaaaa")
        
        // Fill in repeatedPasswordField
        let repeatedPasswordField = app.secureTextFields["repeatedPasswordField"]
        repeatedPasswordField.tap()
        repeatedPasswordField.typeText("aaaaaa")
        
        // Fill in phone number field
        let phoneNumberField = app.textFields["phoneNumberField"]
        phoneNumberField.tap()
        phoneNumberField.typeText("1234567890")
        
        // Can't dismiss numberPad easily, tap on another field then dismiss
        repeatedPasswordField.tap()
        repeatedPasswordField.typeText("\n")
        XCTAssert(app.keyboards.count == 0, "Keyboard is shown, can't tap register button!")
        
        // Tap the register button
        let registerButton = app.buttons["registerButton"]
        registerButton.tap()
        
        // Wait until alert pops up
        let alert = app.alerts["Register"]
        expectation(for: exists, evaluatedWith: alert, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        // Tap OK after sucessful register
        app.alerts["Register"].buttons["OK"].tap()
        
        // View should change to LoginView, assert if true
        XCTAssert(app.navigationBars["dontPeekMe.LoginView"].exists)
    }

    func testCLoginNewAccount() {
        XCTAssert(app.navigationBars["dontPeekMe.LoginView"].exists)
        
        // Fill in username field
        let usernameField = app.textFields["usernameField"]
        usernameField.tap()
        usernameField.typeText("test123@test.com\n")
        
        // Fill in password field
        let passwordField = app.secureTextFields["passwordField"]
        passwordField.tap()
        passwordField.typeText("aaaaaa\n")
        
        // Tap login button
        let loginButton = app.buttons["loginButton"]
        loginButton.tap()
        
        let conversationView = app.tables["conversationsTableView"]
        
        expectation(for: exists, evaluatedWith: conversationView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssert(conversationView.exists)
        
        app.buttons["Sign Out"].tap()
        app.alerts["Sign Out"].buttons["Sign Out"].tap()
        
        let loginView = app.navigationBars["dontPeekMe.LoginView"]
        
        expectation(for: exists, evaluatedWith: loginView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssert(loginView.exists)
    }
}
