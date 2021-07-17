//
//  NewPostInteractorTest.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 17.07.2021.
//

import XCTest
@testable import Lenta

class NewPostInteractorTest: XCTestCase {

    var sut: NewPostInteractor!
    var storageManager: StorageManagerSpy!
    var presenter: NewPostPresenterSpy!
    var networkManager: NetworkManagerMock!

    override func setUpWithError() throws {
        networkManager = NetworkManagerMock()
        storageManager = StorageManagerSpy()
        presenter = NewPostPresenterSpy()
        sut = NewPostInteractor()
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

    func testSeccessSendPost() {
        
        // Arrange
        let postDescription = "Baz"
        let imageData = Data()
        let expectedPresenterNewPostSendFailedCallCount = 0
        let expectedPresenterNewPostSendSuccessCallCount = 1
        let expectedPresenterRecivedError: NetworkServiceError? = nil
        
        // Act
        sut.sendPost(description: postDescription, image: imageData)
        
        // Assert
        XCTAssertEqual(expectedPresenterNewPostSendFailedCallCount, presenter.newPostSendFailedCallCount)
        XCTAssertEqual(expectedPresenterNewPostSendSuccessCallCount, presenter.newPostSendSuccessCallCount)
        XCTAssertEqual(postDescription, presenter.recivedResponse?.posts[0].description)
        XCTAssertEqual(expectedPresenterRecivedError, presenter.recivedError)
    }
    
    func testFailureSendPost() {
        
        // Arrange
        let postDescription = "Bar"
        let imageData = Data()
        let expectedPresenterNewPostSendFailedCallCount = 1
        let expectedPresenterNewPostSendSuccessCallCount = 0
        let expectedPresenterRecivedError: NetworkServiceError? = .network
        
        // Act
        sut.sendPost(description: postDescription, image: imageData)
        
        // Assert
        XCTAssertEqual(expectedPresenterNewPostSendFailedCallCount, presenter.newPostSendFailedCallCount)
        XCTAssertEqual(expectedPresenterNewPostSendSuccessCallCount, presenter.newPostSendSuccessCallCount)
        XCTAssertNil(presenter.recivedResponse)
        XCTAssertEqual(expectedPresenterRecivedError, presenter.recivedError)
    }
}
