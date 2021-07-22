//
//  LentaUITests.swift
//  LentaUITests
//
//  Created by Алексей Алексеев on 08.07.2021.
//

import XCTest

class LentaUITests: XCTestCase {

    var app: XCUIApplication!
    var nameTextField: XCUIElement { app.textFields["nameTextField"]}

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testLoginnedSuccess() {
        LentaPage(app: app)
            .tapProfileButton()
            .tapLogoutButton()
            .tapEnterButton()
            .typeLogin(login: "alex") // if error on simulator, then show keyboard
            .typePassword(password: "a")
            .tapLoginButton()
            .then {
                XCTAssertTrue(nameTextField.value as! String == "Alex")
                XCTAssertFalse(app.alerts["Error loginned"].exists)
            }
    }

    func testLoginnedFailed() {
        LentaPage(app: app)
            .tapProfileButton()
            .tapLogoutButton()
            .tapEnterButton()
            .typeLogin(login: "badlogin") // if error on simulator, then show keyboard
            .typePassword(password: "badpassword")
            .tapLoginButton()
            .then { XCTAssertTrue(app.alerts["Error loginned"].exists) }
    }
}

protocol Page {
    var app: XCUIApplication { get }
    init(app: XCUIApplication)
}

class LentaPage: Page {

    var app: XCUIApplication
    var profileButton: XCUIElement { app.buttons["Profile"] }

    required init(app: XCUIApplication) {
        self.app = app
    }

    func tapProfileButton() -> ProfilePage {
        profileButton.tap()
        return ProfilePage(app: app)
    }
}

class ProfilePage: Page {

    var app: XCUIApplication
    var enterButton: XCUIElement { app.buttons["loginoutBarButton"] }
    var nameTextField: XCUIElement { app.textFields["nameTextField"]}

    required init(app: XCUIApplication) {
        self.app = app
    }

    func tapLogoutButton() -> ProfilePage {
        if nameTextField.value as! String != "----" {
            enterButton.tap()
        }
        return self
    }

    func tapEnterButton() -> LoginPage {
        enterButton.tap()
        return LoginPage(app: app)
    }
}

class LoginPage: Page {

    var app: XCUIApplication
    var registerButton: XCUIElement { app.buttons["Register"] }
    var loginButton: XCUIElement { app.buttons["Login"] }

    required init(app: XCUIApplication) {
        self.app = app
    }

    func typeLogin(login: String) -> LoginPage {
        app.textFields["loginTextField"].tap()
        let chars: [Character] = Array(login)
        chars.forEach { app.keyboards.keys[String($0)].tap() }
        return self
    }

    func typePassword(password: String) -> LoginPage {
        app.secureTextFields["passwordTextField"].tap()
        let chars: [Character] = Array(password)
        chars.forEach { app.keyboards.keys[String($0)].tap() }
        return self
    }

    func tapLoginButton() -> LoginPage {
        loginButton.tap()
        return self
    }

    func then(_ xctest: () -> Void) {
        xctest()
    }
}

class RegisterPage: Page {

    var app: XCUIApplication

    var loginButton: XCUIElement { app.buttons["Login"] }
    var registerButton: XCUIElement { app.buttons["Register"] }

    required init(app: XCUIApplication) {
        self.app = app
    }

    func tapRegisterButton() {

    }
}
