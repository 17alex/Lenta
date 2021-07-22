//
//  CommentsInteractorTest.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 22.07.2021.
//


import XCTest
@testable import Lenta

class CommentsInteractorTest: XCTestCase {
    
    var sut: CommentsInteractor!
    var presenter: CommentsPresenterSpy!
    var networkManager: NetworkManagerMock!
    var storageManager: StorageManagerSpy!
    
    override func setUpWithError() throws {
        
        networkManager = NetworkManagerMock()
        storageManager = StorageManagerSpy()
        presenter = CommentsPresenterSpy()
        sut = CommentsInteractor()
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

    func testSuccessSendNewComment()  {

        // Arrange
        let comment = "Baz"
        let expectedNetworkSendCommentCallCount = 1
        let expectedPresenterDidSendCommentCallCount = 1
        let expectedPresenterShowCallCount = 0

        sut.currentUser = User(id: 0, name: "User0", postsCount: 0, dateRegister: 0, avatar: "avatar")
        sut.posts = [
            Post(id: 0, userId: 0, timeInterval: 0, description: "Post0",
                 photo: nil, likeUserIds: [0], viewsCount: 0, commentsCount: 0)
        ]

        // Act
        sut.sendNewComment(comment)

        // Assert
        XCTAssertEqual(comment, networkManager.recivedNewComment)
        XCTAssertEqual(expectedNetworkSendCommentCallCount, networkManager.sendCommentCallCount)
        XCTAssertEqual(expectedPresenterDidSendCommentCallCount, presenter.didSendCommentCallCount)
        XCTAssertEqual(sut.comments.first?.text, networkManager.comment.text)
        XCTAssertEqual(expectedPresenterShowCallCount, presenter.showCallCount)

    }

    func testFailureSendNewComment()  {

        // Arrange
        let comment = "Baz"
        let expectedNetworkSendCommentCallCount = 1
        let expectedPresenterDidSendCommentCallCount = 0
        let expectedPresenterShowCallCount = 1

        sut.currentUser = User(id: 0, name: "User0", postsCount: 0, dateRegister: 0, avatar: "avatar")
        sut.posts = [
            Post(id: 1, userId: 0, timeInterval: 0, description: "Post0",
                 photo: nil, likeUserIds: [0], viewsCount: 0, commentsCount: 0)
        ]

        // Act
        sut.sendNewComment(comment)

        // Assert
        XCTAssertEqual(comment, networkManager.recivedNewComment)
        XCTAssertEqual(expectedNetworkSendCommentCallCount, networkManager.sendCommentCallCount)
        XCTAssertEqual(expectedPresenterDidSendCommentCallCount, presenter.didSendCommentCallCount)
        XCTAssertEqual(expectedPresenterShowCallCount, presenter.showCallCount)

    }

    func testSuccessLoadComments()  {

        // Arrange
        let postId: Int16 = 0
        let expectedNetworkLoadCommentsCallCount = 1

        // Act
        sut.loadComments(byPostId: postId)

        // Assert
        XCTAssertEqual(postId, networkManager.recivePostId)
        XCTAssertEqual(expectedNetworkLoadCommentsCallCount, networkManager.loadCommentsCallCount)
        XCTAssertEqual(sut.comments.first?.text, networkManager.responseComment.comments.first?.text)
        XCTAssertEqual(sut.posts.first?.description, networkManager.responseComment.posts.first?.description)
    }

    func testFailureLoadComments()  {

        // Arrange
        let postId: Int16 = 1
        let expectedNetworkLoadCommentsCallCount = 1
        let expectedPresenterShowCallCount = 1
        let expectedRecivedPostCoiunt = 0
        let expectedRecivedCommentsCount = 0

        // Act
        sut.loadComments(byPostId: postId)

        // Assert
        XCTAssertEqual(postId, networkManager.recivePostId)
        XCTAssertEqual(expectedNetworkLoadCommentsCallCount, networkManager.loadCommentsCallCount)
        XCTAssertEqual(sut.comments.count, expectedRecivedCommentsCount)
        XCTAssertEqual(sut.posts.count, expectedRecivedPostCoiunt)
        XCTAssertEqual(expectedPresenterShowCallCount, presenter.showCallCount)
    }
}
