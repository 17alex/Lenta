//
//  UserInfoInteractorTest.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 22.07.2021.
//

import XCTest
@testable import Lenta

final class UserInfoInteractorTest: XCTestCase {
    
    var sut: UserInfoInteractor!
    var networkManager: NetworkManagerMock!

    override func setUpWithError() throws {
        networkManager = NetworkManagerMock()
        sut = UserInfoInteractor()
        sut.networkManager = networkManager
    }

    override func tearDownWithError() throws {
        networkManager = nil
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
}
