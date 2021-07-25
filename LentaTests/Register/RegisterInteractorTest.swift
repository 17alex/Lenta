//
//  RegisterInteractorTest.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 03.07.2021.
//

import XCTest
@testable import Lenta

class RegisterInteractorTest: XCTestCase {

    var sut: RegisterInteractor!
    var presenter: RegisterPresenterSpy!
    var networkManager: NetworkManagerMock!
    var storageManager: StorageManagerSpy!

    override func setUpWithError() throws {

        networkManager = NetworkManagerMock()
        storageManager = StorageManagerSpy()
        presenter = RegisterPresenterSpy()
        sut = RegisterInteractor(presenter: presenter)
        sut.networkManager = networkManager
        sut.storageManager = storageManager
    }

    override func tearDownWithError() throws {

        networkManager = nil
        storageManager = nil
        presenter = nil
        sut = nil
    }

    func testSuccessRegister() {

        // Arrange
        let rightUserName = "Bar"
        let rightUserLogin = "Boo"
        let rightUserPassword = "Baz"
        let userAvatarImage = Data()

        let expectNetworkCallCount = 1
        let expectedStorageCallCount = 1
        let expectedPresenterUserDidRegisterCallCount = 1
        let expectedPresenterUserRegisterFailCallCount = 0
        let expectedStorageAppendUserCallCount = 1
        let expectedPresenterUserRegisterFailMessage: NetworkServiceError? = nil

        // Act
        sut.register(name: rightUserName, login: rightUserLogin, password: rightUserPassword,
                     avatarImage: userAvatarImage)

        // Assert
        XCTAssertEqual(networkManager.registerCallCount, expectNetworkCallCount)
        XCTAssertEqual(rightUserName, networkManager.recivedUserName)
        XCTAssertEqual(rightUserLogin, networkManager.recivedUserLogin)
        XCTAssertEqual(rightUserPassword, networkManager.recivedUserPassword)
        XCTAssertEqual(expectedStorageCallCount, storageManager.saveUserCallCount)
        XCTAssertEqual(expectedPresenterUserDidRegisterCallCount, presenter.userDidRegisterCount)
        XCTAssertEqual(expectedPresenterUserRegisterFailCallCount, presenter.userRegisterFailCount)
        XCTAssertEqual(expectedPresenterUserRegisterFailMessage, presenter.recivedError)
        XCTAssertEqual(expectedStorageAppendUserCallCount, storageManager.appendUserCallCount)
    }

    func testFailureRegister() {

        // Arrange
        let badUserName = "Baa"
        let badUserLogin = "Bbo"
        let badUserPassword = "Bzz"
        let userAvatarImage: Data? = nil

        let expectNetworkCallCount = 1
        let expectedStorageCallCount = 0
        let expectedPresenterUserDidRegisterCallCount = 0
        let expectedPresenterUserRegisterFailCallCount = 1
        let expectedPresenterRecivedError: NetworkServiceError? = .network

        // Act
        sut.register(name: badUserName, login: badUserLogin, password: badUserPassword, avatarImage: userAvatarImage)

        // Assert
        XCTAssertEqual(networkManager.registerCallCount, expectNetworkCallCount)
        XCTAssertEqual(badUserName, networkManager.recivedUserName)
        XCTAssertEqual(badUserLogin, networkManager.recivedUserLogin)
        XCTAssertEqual(badUserPassword, networkManager.recivedUserPassword)
        XCTAssertEqual(expectedStorageCallCount, storageManager.saveUserCallCount)
        XCTAssertEqual(expectedPresenterUserDidRegisterCallCount, presenter.userDidRegisterCount)
        XCTAssertEqual(expectedPresenterUserRegisterFailCallCount, presenter.userRegisterFailCount)
        XCTAssertEqual(expectedPresenterRecivedError, presenter.recivedError)
    }
}
