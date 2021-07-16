//
//  LoginInteractorTest.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 24.06.2021.
//

import XCTest
@testable import Lenta

class LoginInteractorTest: XCTestCase {

    var sut: LoginInteractor!
    var presenter: LoginPresenterSpy!
    var networkManager: NetworkManagerMock!
    var storageManager: storageManagerSpy!

    override func setUpWithError() throws {
        networkManager = NetworkManagerMock()
        storageManager = storageManagerSpy()
        presenter = LoginPresenterSpy()
        sut = LoginInteractor(presenter: presenter)
        sut.networkManager = networkManager
        sut.storageManager = storageManager
    }

    override func tearDownWithError() throws {
        networkManager = nil
        storageManager = nil
        presenter = nil
        sut = nil
    }

    func testSuccessLoginned() {

        // Arrange
        let rightLogin = "Boo"
        let rightPassword = "Baz"

        let expectNetworkCallCount = 1
        let expectedStorageCallCount = 1
        let expectedUserDidLoginnedCallCount = 1
        let expectedUserLoginFailCallCount = 0
        let expectedUserLoginFailMessage = ""

        // Act
        sut.logIn(login: rightLogin, password: rightPassword)

        // Assert
        XCTAssertEqual(networkManager.logInCallCount, expectNetworkCallCount)
        XCTAssertEqual(rightLogin, networkManager.recivedUserLogin)
        XCTAssertEqual(rightPassword, networkManager.recivedUserPassword)
        XCTAssertEqual(expectedStorageCallCount, storageManager.saveUserCallCount)
        XCTAssertEqual(expectedUserDidLoginnedCallCount, presenter.userDidLoginedCount)
        XCTAssertEqual(expectedUserLoginFailCallCount, presenter.userLoginFailCount)
        XCTAssertEqual(expectedUserLoginFailMessage, presenter.message)
    }

    func testFailureLoginned() {

        // Arrange
        let badLogin = "Baa"
        let badPassword = "Bzz"

        let expectNetworkCallCount = 1
        let expectedStorageCallCount = 0
        let expectedUserDidLoginnedCallCount = 0
        let expectedUserLoginFailCallCount = 1
        let expectedUserLoginFailMessage = NetworkServiceError.network.rawValue

        // Act
        sut.logIn(login: badLogin, password: badPassword)

        // Assert
        XCTAssertEqual(networkManager.logInCallCount, expectNetworkCallCount)
        XCTAssertEqual(badLogin, networkManager.recivedUserLogin)
        XCTAssertEqual(badPassword, networkManager.recivedUserPassword)
        XCTAssertEqual(expectedStorageCallCount, storageManager.saveUserCallCount)
        XCTAssertEqual(expectedUserDidLoginnedCallCount, presenter.userDidLoginedCount)
        XCTAssertEqual(expectedUserLoginFailCallCount, presenter.userLoginFailCount)
        XCTAssertEqual(expectedUserLoginFailMessage, presenter.message)
    }
}
