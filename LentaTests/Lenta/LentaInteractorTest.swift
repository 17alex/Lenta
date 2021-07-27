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
    var storageManager: StorageManagerSpy!
    var presenter: LentaPresenterSpy!
    var networkManager: NetworkManagerMock!

    override func setUpWithError() throws {
        networkManager = NetworkManagerMock()
        storageManager = StorageManagerSpy()
        presenter = LentaPresenterSpy()
        sut = LentaInteractor()
        sut.presenter = presenter
        sut.storageManager = storageManager
        sut.networkManager = networkManager
    }

    override func tearDownWithError() throws {
        networkManager = nil
        storageManager = nil
        presenter = nil
        sut = nil
    }

    func testGetCurrentUser() {

        // Arrange
        let expectedStorageCallCount = 1

        // Act
        sut.getCurrenUser()

        // Assert
        XCTAssertEqual(expectedStorageCallCount, storageManager.getCurrenUserCallCount)
        XCTAssertEqual(storageManager.sendedUser, sut.currentUser)
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
        let expectedPresenterRecivedError: NetworkServiceError? = nil

        // Act
        sut.changeLike(by: postIndex)

        // Assert
        XCTAssertEqual(expectedPostId, networkManager.recivePostId)
        XCTAssertEqual(expectedUserId, networkManager.reciveUserId)
        XCTAssertEqual(expectedChangeLikeCallCount, networkManager.changeLikeCallCount)
        XCTAssertEqual(sut.posts[postIndex].id, networkManager.post.id)
        XCTAssertEqual(expectedDidUpdatePostCallCount, presenter.didUpdatePostCallCount)
        XCTAssertEqual(expectedRecivedIndex, presenter.recivedIndex)
        XCTAssertEqual(expectedShowMessageCallCount, presenter.showMessageCallCount)
        XCTAssertEqual(expectedPresenterRecivedError, presenter.recivedError)
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
        let expectedPresenterRecivedError: NetworkServiceError? = .network

        // Act
        sut.changeLike(by: postIndex)

        // Assert
        XCTAssertEqual(expectedPostId, networkManager.recivePostId)
        XCTAssertEqual(expectedUserId, networkManager.reciveUserId)
        XCTAssertEqual(expectedChangeLikeCallCount, networkManager.changeLikeCallCount)
        XCTAssertEqual(expectedDidUpdatePostCallCount, presenter.didUpdatePostCallCount)
        XCTAssertEqual(expectedRecivedIndex, presenter.recivedIndex)
        XCTAssertEqual(expectedShowMessageCallCount, presenter.showMessageCallCount)
        XCTAssertEqual(expectedPresenterRecivedError, presenter.recivedError)
    }
    
    func testSuccessDeletePost() {
        
        // Arrange
        let postIndex = 0
        sut.currentUser = User(id: 0, name: "User0", postsCount: 0, dateRegister: 0, avatar: "avatar")
        sut.posts = [
            Post(id: 0, userId: 0, timeInterval: 0, description: "Post0",
                 photo: nil, likeUserIds: [0], viewsCount: 0, commentsCount: 0),
            Post(id: 1, userId: 0, timeInterval: 0, description: "Post1",
                 photo: nil, likeUserIds: [0], viewsCount: 0, commentsCount: 0)
        ]

        let expectedNetworkPostId: Int16 = 0
        let expectedNetworkRemovePostCallCount = 1
        let expectedPostCountAfterDelete = 1
        let expectedPresenterDidRemovePostCallCount = 1
        let expectedPresenterRecivedIndex = 0
        let expectedPresenterShowMessageCallCount = 0
        let expectedPresenterRecivedError: NetworkServiceError? = nil
        let expectedStorageSavePostsCallCount = 1
        let expectedStorageSavedPostCount = 1
        
        // Act
        sut.deletePost(by: postIndex)
        
        // Assert
        XCTAssertEqual(expectedNetworkPostId, networkManager.recivePostId)
        XCTAssertEqual(expectedNetworkRemovePostCallCount, networkManager.removePostCallCount)
        XCTAssertEqual(sut.posts.count, expectedPostCountAfterDelete)
        XCTAssertEqual(expectedPresenterDidRemovePostCallCount, presenter.didRemovePostCallCount)
        XCTAssertEqual(expectedPresenterRecivedIndex, presenter.recivedIndex)
        XCTAssertEqual(expectedPresenterShowMessageCallCount, presenter.showMessageCallCount)
        XCTAssertEqual(expectedPresenterRecivedError, presenter.recivedError)
        XCTAssertEqual(expectedStorageSavePostsCallCount, storageManager.savePostsCallCount)
        XCTAssertEqual(expectedStorageSavedPostCount, storageManager.savedPosts.count)
    }
    
    func testFailureDeletePost() {
        
        // Arrange
        let postIndex = 1
        sut.currentUser = User(id: 0, name: "Baz", postsCount: 1, dateRegister: 1234, avatar: "avatar")
        sut.posts = [
            Post(id: 0, userId: 0, timeInterval: 0, description: "Post0",
                 photo: nil, likeUserIds: [0], viewsCount: 0, commentsCount: 0),
            Post(id: 1, userId: 0, timeInterval: 0, description: "Post1",
                 photo: nil, likeUserIds: [0], viewsCount: 0, commentsCount: 0)
        ]

        let expectedNetworkPostId: Int16 = 1
        let expectedNetworkRemovePostCallCount = 1
        let expectedPostCountAfterDelete = 2
        let expectedPresenterDidRemovePostCallCount = 0
        let expectedPresenterRemovePostRecivedIndex = -1
        let expectedPresenterShowMessageCallCount = 1
        let expectedPresenterRecivedError = NetworkServiceError.network
        let expectedStorageSavePostsCallCount = 0
        let expectedStorageSavedPostCount = 0
        
        // Act
        sut.deletePost(by: postIndex)
        
        // Assert
        XCTAssertEqual(expectedNetworkPostId, networkManager.recivePostId)
        XCTAssertEqual(expectedNetworkRemovePostCallCount, networkManager.removePostCallCount)
        XCTAssertEqual(sut.posts.count, expectedPostCountAfterDelete)
        XCTAssertEqual(expectedPresenterDidRemovePostCallCount, presenter.didRemovePostCallCount)
        XCTAssertEqual(expectedPresenterRemovePostRecivedIndex, presenter.recivedIndex)
        XCTAssertEqual(expectedPresenterShowMessageCallCount, presenter.showMessageCallCount)
        XCTAssertEqual(expectedPresenterRecivedError, presenter.recivedError)
        XCTAssertEqual(expectedStorageSavePostsCallCount, storageManager.savePostsCallCount)
        XCTAssertEqual(expectedStorageSavedPostCount, storageManager.savedPosts.count)
    }
    
    func testLoadFromStorage() {
        
        // Arrange
        let expectedStorageLoadCallCount = 1
        let expectedPostsCount = 1
        let expectedUsersCount = 1
        
        // Act
        sut.loadFromStorage()
        
        // Assert
        XCTAssertEqual(expectedStorageLoadCallCount, storageManager.loadCallCount)
        XCTAssertEqual(expectedPostsCount, sut.posts.count)
        XCTAssertEqual(expectedUsersCount, sut.users.count)
    }
    
    func testGetCurrenUser()  {
        
        // Arrange
        let expectedStorageGetCurrenUserCallCount = 1
        
        // Act
        sut.getCurrenUser()
        
        // Assert
        XCTAssertEqual(expectedStorageGetCurrenUserCallCount, storageManager.getCurrenUserCallCount)
        XCTAssertEqual(storageManager.sendedUser.name, sut.currentUser?.name)
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

    func testAddNewPost()  {

        // Arrange
        let expectedPostsCount = 1
        let expectedUsersCount = 1
        let expectedAppendCallCount = 1
        let expectedPresenterDidLoadNewCallCount = 1
        let expectedStoragUpdateCallCount = 1

        let user = User(id: 0, name: "Baz", postsCount: 0, dateRegister: 0, avatar: "Avatar")
        let post = Post(id: 0, userId: 0, timeInterval: 0, description: "Boo", photo: nil, likeUserIds: [], viewsCount: 0, commentsCount: 0)
        let response = Response(posts: [post], users: [user])

        // Act
        sut.addNewPost(response: response)

        // Assert
        XCTAssertEqual(expectedPostsCount, sut.posts.count)
        XCTAssertEqual(expectedUsersCount, sut.users.count)
        XCTAssertEqual(expectedAppendCallCount, storageManager.appendPostsCallCount)
        XCTAssertEqual(response.posts.count, storageManager.savedPosts.count)
        XCTAssertEqual(expectedPresenterDidLoadNewCallCount, presenter.didLoadNewCallCount)
        XCTAssertEqual(post.description, presenter.recivedPost?.description)
        XCTAssertEqual(expectedStoragUpdateCallCount, storageManager.updateUserCallCount)
    }

    func testSuccesLoadPosts() {

        // Arrange
        let expectedNetworkRecivedFromPostId: Int16? = nil
        let expectedNetworkGetPostsCallCount = 1
        let expectedPresenterDidLoadFirstCallCount = 1
        let expectedPresenterRecivedPostsCount = 1
        let expectedStorageSavePostsCallCount = 1
        let expectedStorageSaveUsersCallCount = 1

        // Act
        sut.isEndingPosts = false
        sut.loadPosts()

        // Assert
        XCTAssertEqual(expectedNetworkRecivedFromPostId, networkManager.recivedFromPostId)
        XCTAssertEqual(expectedNetworkGetPostsCallCount, networkManager.getPostsCallCount)
        XCTAssertEqual(expectedPresenterDidLoadFirstCallCount, presenter.didLoadFirstCallCount)
        XCTAssertEqual(expectedPresenterRecivedPostsCount, presenter.recivedPosts.count)
        XCTAssertEqual(expectedStorageSavePostsCallCount, storageManager.savePostsCallCount)
        XCTAssertEqual(expectedStorageSaveUsersCallCount, storageManager.saveUsersCallCount)

    }

    func testSuccesLoadNextPosts() {

        // Arrange
        let expectedNetworkRecivedFromPostId: Int16? = 0
        let expectedNetworkGetPostsCallCount = 1
        let expectedPresenterDidLoadNextCallCount = 1
        let expectedPresenterRecivedPostsCount = 1
        let expectedStorageAppendCallCount = 1
        let expectedStorageSaveUsersCallCount = 1
        let posts = [Post(id: 0, userId: 0, timeInterval: 0, description: "", photo: nil, likeUserIds: [], viewsCount: 0, commentsCount: 0)]

        // Act
        sut.isEndingPosts = false
        sut.posts = posts
        sut.loadNextPosts()

        // Assert
        XCTAssertEqual(expectedNetworkRecivedFromPostId, networkManager.recivedFromPostId)
        XCTAssertEqual(expectedNetworkGetPostsCallCount, networkManager.getPostsCallCount)
        XCTAssertEqual(expectedPresenterDidLoadNextCallCount, presenter.didLoadNextCallCount)
        XCTAssertEqual(expectedPresenterRecivedPostsCount, presenter.recivedPosts.count)
        XCTAssertEqual(expectedStorageAppendCallCount, storageManager.appendPostsCallCount)
        XCTAssertEqual(expectedStorageSaveUsersCallCount, storageManager.saveUsersCallCount)
    }
}
