//
//  LoginInteractorTest.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 24.06.2021.
//

import XCTest
@testable import Lenta

final class LoginPresenterMock: LoginInteractorOutput {
    
    var userDidLoginedCount = 0
    var userLoginFailCount = 0
    var message = ""
    
    func userDidLogined() {
        userDidLoginedCount += 1
    }
    
    func userLoginFail(message: String) {
        userLoginFailCount += 1
        self.message = message
    }
}

final class NetworkManagerMock: NetworkManagerProtocol {
    
    var logInCount = 0
    var login = ""
    var password = ""
    
    func logIn(login: String, password: String, complete: @escaping (Result<[User], NetworkServiceError>) -> Void) {
        self.login = login
        self.password = password
        logInCount += 1
    }
    
    func register(name: String, login: String, password: String, avatar: UIImage?, complete: @escaping (Result<[User], NetworkServiceError>) -> Void) {
        
    }
    
    func getPosts(fromPostId: Int?, complete: @escaping (Result<Response, NetworkServiceError>) -> Void) {
        
    }
    
    func sendPost(post: SendPost, complete: @escaping (Result<Response, NetworkServiceError>) -> Void) {
        
    }
    
    func updateProfile(id: Int, name: String, avatar: UIImage?, complete: @escaping (Result<[User], NetworkServiceError>) -> Void) {
        
    }
    
    func changeLike(postId: Int, userId: Int, complete: @escaping (Result<Post, NetworkServiceError>) -> Void) {
        
    }
    
    func removePost(postId: Int, complete: @escaping (Result<Response, NetworkServiceError>) -> Void) {
        
    }
    
    func loadComments(for postId: Int, complete: @escaping (Result<ResponseComment, NetworkServiceError>) -> Void) {
        
    }
    
    func sendComment(_ comment: String, postId: Int, userId: Int, complete: @escaping (Result<ResponseComment, NetworkServiceError>) -> Void) {
        
    }
    
    
}

class LoginInteractorTest: XCTestCase {

    var interactor: LoginInteractor!
    var presenter: LoginPresenterMock!
    var network: NetworkManagerMock!
    
    override func setUpWithError() throws {
        
        network = NetworkManagerMock()
        presenter = LoginPresenterMock()
        interactor = LoginInteractor(presenter: presenter)
        interactor.networkManager = network
    }

    override func tearDownWithError() throws {
        
        presenter  = nil
        interactor = nil
    }

    func test() {
        
        //Arrange
        let login = "bar"
        let password = "baz"
        let expectCountNetworkCall = 1
//        let validatorExpectation = expectation(description: "Expectation in" + #function)
        
        //Act
        interactor.logIn(login: login, password: password)
        
        //Assert
        XCTAssertEqual(network.logInCount, expectCountNetworkCall)
        XCTAssertEqual(login, network.login)
        XCTAssertEqual(password, network.password)
        
        waitForExpectations(timeout: 0.5) { (error) in
            if error != nil { XCTFail() }
            
                
        }
    }


}

