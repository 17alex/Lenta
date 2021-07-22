//
//  ProfileInteractorTest.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 22.07.2021.
//

import XCTest
@testable import Lenta

class ProfileInteractorTest: XCTestCase {

    var sut: ProfileInteractor!
    var presenter: ProfilePresenterSpy!
    var networkManager: NetworkManagerMock!
    var storageManager: StorageManagerSpy!

    override func setUpWithError() throws {

        networkManager = NetworkManagerMock()
        storageManager = StorageManagerSpy()
        presenter = ProfilePresenterSpy()
        sut = ProfileInteractor()
        sut.presenter = presenter
        sut.networkManager = networkManager
        sut.storageManager = storageManager
    }

    override func tearDownWithError() throws {

        networkManager = nil
        storageManager = nil
        presenter = nil
        sut = nil
    }

    func testStart() {

        // Arrange
        let expectedStorageGetCurrentUserCallCount = 1
        let expectedPresenterCurrentUserCallCount = 1
        let expectedPresenterChangeProfileCallCount = 1
        let expectedPresenterRecivedProfileChangeValue = false

        // Act
        sut.start()

        // Assert
        XCTAssertEqual(expectedStorageGetCurrentUserCallCount, storageManager.getCurrenUserCallCount)
        XCTAssertEqual(expectedPresenterCurrentUserCallCount, presenter.currentUserCallCoutn)
        XCTAssertEqual(storageManager.sendedUser, presenter.recivedUser)
        XCTAssertEqual(expectedPresenterChangeProfileCallCount, presenter.changeProfileCallCount)
        XCTAssertEqual(expectedPresenterRecivedProfileChangeValue, presenter.recivedProfileChangeValue)
    }

    func testGetImage()  {

        // Arrange
        let urlString = "Baz"
        var expectedData: Data?
        let expectedNetworkLoadImageCallCount = 1

        // Act
        sut.getImage(from: urlString) { recivedData in
            expectedData = recivedData
        }

        // Assert
        XCTAssertEqual(expectedNetworkLoadImageCallCount, networkManager.loadImageCallCount)
        XCTAssertEqual(expectedData, networkManager.sendedData)
    }

    func testDidSelectNewAvatar() {

        // Arrange
        let expectedBollValue = true

        // Act
        sut.didSelectNewAvatar()

        // Assert
        XCTAssertEqual(expectedBollValue, sut.isSetNewAvatar)
    }

    func testChange() {

        // Arrange
        let expectedName = "Boo"

        // Act
        sut.change(name: expectedName)

        // Assert
        XCTAssertEqual(expectedName, sut.newName)
    }

    func testLogInButtonPress() {

        // Arrange
        let expectedPresenterToLoginCallCount = 1

        // Act
        sut.logInOutButtonPress()

        // Assert
        XCTAssertEqual(expectedPresenterToLoginCallCount, presenter.toLoginCallCount)
    }

    func testLogOutButtonPress() {

        // Arrange
        let expectedPresenterToLoginCallCount = 0
        let expectedCurrentUser: User? = nil
        let expectedStorageSaveUserCallCount = 1
        let expectedStorageCurrentUser: User? = nil
        let expectedPresenterCurrentusser: User? = nil
        let expectedPresenterCurrentUserCallCoutn = 1

        let user = User(id: 0, name: "Baz", postsCount: 0, dateRegister: 0, avatar: "Boo")

        // Act
        sut.currentUser = user
        sut.logInOutButtonPress()

        // Assert
        XCTAssertEqual(expectedPresenterToLoginCallCount, presenter.toLoginCallCount)
        XCTAssertEqual(expectedCurrentUser, sut.currentUser)
        XCTAssertEqual(expectedStorageSaveUserCallCount, storageManager.saveUserCallCount)
        XCTAssertEqual(expectedStorageCurrentUser, storageManager.savedUser)
        XCTAssertEqual(expectedPresenterCurrentusser, presenter.recivedUser)
        XCTAssertEqual(expectedPresenterCurrentUserCallCoutn, presenter.currentUserCallCoutn)
    }

    func testSuccessSaveProfile() {

        // Arrange
        let imageData = Data()
        let expectedNetworkUpdateProfileCallCount = 1
        let expectedPresenterSaveProfileSuccessCallCount = 1
        let expectedIsSetNewAvatar = false
        let user = User(id: 0, name: "Baz", postsCount: 0, dateRegister: 0, avatar: "Boo")

        // Act
        sut.currentUser = user
        sut.isSetNewAvatar = true
        sut.saveProfile(name: user.name, image: imageData)

        // Assert
        XCTAssertEqual(expectedNetworkUpdateProfileCallCount, networkManager.updateProfileCallCount)
        XCTAssertEqual(user.id, networkManager.reciveUserId)
        XCTAssertEqual(user.name, networkManager.recivedUserName)
        XCTAssertEqual(imageData, networkManager.recivadAvatarImageData)
        XCTAssertEqual(expectedPresenterSaveProfileSuccessCallCount, presenter.saveProfileSuccessCallCount)
        XCTAssertEqual(expectedIsSetNewAvatar, sut.isSetNewAvatar)
    }

    func testFailureSaveProfile() {

        // Arrange
        let imageData = Data()
        let expectedNetworkUpdateProfileCallCount = 1
        let expectedPresenterSaveProfileSuccessCallCount = 0
        let expectedPresenterSaveProfileFailedCallCount = 1
        let expectedPresenterSaveProfileError: NetworkServiceError = .network
        let user = User(id: 1, name: "Baz", postsCount: 0, dateRegister: 0, avatar: "Boo")

        // Act
        sut.currentUser = user
        sut.isSetNewAvatar = true
        sut.saveProfile(name: user.name, image: imageData)

        // Assert
        XCTAssertEqual(expectedNetworkUpdateProfileCallCount, networkManager.updateProfileCallCount)
        XCTAssertEqual(expectedPresenterSaveProfileFailedCallCount, presenter.saveProfileFailedCallCount)
        XCTAssertEqual(expectedPresenterSaveProfileError, presenter.recivedServiceError)
        XCTAssertEqual(expectedPresenterSaveProfileSuccessCallCount, presenter.saveProfileSuccessCallCount)
    }
}
