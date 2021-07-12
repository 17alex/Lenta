//
//  LentaInteractorTest.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 03.07.2021.
//

import XCTest
@testable import Lenta

final class LentaInteractorTest: XCTestCase {

    var sut: LentaInteractor!
    var storeManager: StoreManagerSpy!
    var presenter: LentaPresenterSpy!
    var networkManager: NetworkManagerMock!

    override func setUpWithError() throws {
        networkManager = NetworkManagerMock()
        storeManager = StoreManagerSpy()
        presenter = LentaPresenterSpy()
        sut = LentaInteractor()
        sut.presenter = presenter
        sut.storeManager = storeManager
        sut.networkManager = networkManager
    }

    override func tearDownWithError() throws {
        networkManager = nil
        storeManager = nil
        presenter = nil
        sut = nil
    }

    func testGetCurrentUser() {

        // Arrange
        let expectedStoreCallCount = 1

        // Act
        sut.getCurrenUser()

        // Assert
        XCTAssertEqual(expectedStoreCallCount, storeManager.getCurrenUserCallCount)
        XCTAssertEqual(storeManager.sendUser, sut.currentUser)
    }

    func testSuccessChangeLike() {

        // Arrange
        let postIndex = 0
        sut.currentUser = User(id: 0, name: "Baz", postsCount: 1, dateRegister: 1234, avatar: "avatar")
        sut.posts = [Post(id: 0, userId: 0, timeInterval: 2345, description: "Bar",
                          photo: nil, likeUserIds: [0], viewsCount: 1, commentsCount: 0)]

        let expectedPostId: Int16 = 0
        let expectedUserId: Int16 = 0
        let expectedChangeLikeCallCount = 1
        let expectedDidUpdatePostCallCount = 1
        let expectedRecivedIndex = 0
        let expectedShowMessageCallCount = 0
        let expectedMessage = ""

        // Act
        sut.changeLike(by: postIndex)

        // Assert
        XCTAssertEqual(expectedPostId, networkManager.recivePostId)
        XCTAssertEqual(expectedUserId, networkManager.reciveUserId)
        XCTAssertEqual(expectedChangeLikeCallCount, networkManager.changeLikeCallCount)
        XCTAssertEqual(sut.posts[postIndex].id, networkManager.post.id)
        XCTAssertEqual(expectedDidUpdatePostCallCount, presenter.didUpdatePostCallCount)
        XCTAssertEqual(expectedRecivedIndex, presenter.recivedIndex)
        XCTAssertEqual(expectedShowMessageCallCount, presenter.expectedShowMessageCallCount)
        XCTAssertEqual(expectedMessage, presenter.recivedMessage)
    }

    func testFailureChangeLike() {

        // Arrange
        let postIndex = 0
        sut.currentUser = User(id: -1, name: "Baz", postsCount: 1, dateRegister: 1234, avatar: "avatar")
        sut.posts = [Post(id: -1, userId: 0, timeInterval: 2345, description: "Bar",
                          photo: nil, likeUserIds: [0], viewsCount: 1, commentsCount: 0)]

        let expectedPostId: Int16 = -1
        let expectedUserId: Int16 = -1
        let expectedChangeLikeCallCount = 1
        let expectedDidUpdatePostCallCount = 0
        let expectedRecivedIndex = -1
        let expectedShowMessageCallCount = 1
        let expectedMessage = NetworkServiceError.network.rawValue

        // Act
        sut.changeLike(by: postIndex)

        // Assert
        XCTAssertEqual(expectedPostId, networkManager.recivePostId)
        XCTAssertEqual(expectedUserId, networkManager.reciveUserId)
        XCTAssertEqual(expectedChangeLikeCallCount, networkManager.changeLikeCallCount)
        XCTAssertEqual(expectedDidUpdatePostCallCount, presenter.didUpdatePostCallCount)
        XCTAssertEqual(expectedRecivedIndex, presenter.recivedIndex)
        XCTAssertEqual(expectedShowMessageCallCount, presenter.expectedShowMessageCallCount)
        XCTAssertEqual(expectedMessage, presenter.recivedMessage)
    }
}
