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
    var storeManager: StoreManagerSpy!
    
    override func setUpWithError() throws {
        
        networkManager = NetworkManagerMock()
        storeManager = StoreManagerSpy()
        presenter = RegisterPresenterSpy()
        sut = RegisterInteractor(presenter: presenter)
        sut.networkManager = networkManager
        sut.storeManager = storeManager
    }

    override func tearDownWithError() throws {
        
        networkManager = nil
        storeManager = nil
        presenter  = nil
        sut = nil
    }

    func testSuccessRegister() {
        
        //Arrange
        let rightUserName = "Bar"
        let rightUserLogin = "Boo"
        let rightUserPassword = "Baz"
        let userAvatarImage = UIImage()

        let expectNetworkCallCount = 1
        let expectedStoreCallCount = 1
        let expectedUserDidRegisterCallCount = 1
        let expectedUserRegisterFailCallCount = 0
        let expectedUserRegisterFailMessage = ""
        
        //Act
        sut.register(name: rightUserName, login: rightUserLogin, password: rightUserPassword, avatarImage: userAvatarImage)
        
        //Assert
        XCTAssertEqual(networkManager.registerCallCount, expectNetworkCallCount)
        XCTAssertEqual(rightUserName, networkManager.recivedUserName)
        XCTAssertEqual(rightUserLogin, networkManager.recivedUserLogin)
        XCTAssertEqual(rightUserPassword, networkManager.recivedUserPassword)
        XCTAssertEqual(expectedStoreCallCount, storeManager.saveUserCallCount)
        XCTAssertEqual(expectedUserDidRegisterCallCount, presenter.userDidRegisterCount)
        XCTAssertEqual(expectedUserRegisterFailCallCount, presenter.userRegisterFailCount)
        XCTAssertEqual(expectedUserRegisterFailMessage, presenter.message)
    }
    
    func testFailureRegister() {

        //Arrange
        let badUserName = "Baa"
        let badUserLogin = "Bbo"
        let badUserPassword = "Bzz"
        let userAvatarImage: UIImage? = nil
        
        let expectNetworkCallCount = 1
        let expectedStoreCallCount = 0
        let expectedUserDidRegisterCallCount = 0
        let expectedUserRegisterFailCallCount = 1
        let expectedUserRegisterFailMessage = NetworkServiceError.network.rawValue
        
        //Act
        sut.register(name: badUserName, login: badUserLogin, password: badUserPassword, avatarImage: userAvatarImage)
        
        //Assert
        XCTAssertEqual(networkManager.registerCallCount, expectNetworkCallCount)
        XCTAssertEqual(badUserName, networkManager.recivedUserName)
        XCTAssertEqual(badUserLogin, networkManager.recivedUserLogin)
        XCTAssertEqual(badUserPassword, networkManager.recivedUserPassword)
        XCTAssertEqual(expectedStoreCallCount, storeManager.saveUserCallCount)
        XCTAssertEqual(expectedUserDidRegisterCallCount, presenter.userDidRegisterCount)
        XCTAssertEqual(expectedUserRegisterFailCallCount, presenter.userRegisterFailCount)
        XCTAssertEqual(expectedUserRegisterFailMessage, presenter.message)
    }
}
