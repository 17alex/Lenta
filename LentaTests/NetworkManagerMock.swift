//
//  NetworkManagerMock.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 03.07.2021.
//

import UIKit
@testable import Lenta

final class NetworkManagerMock: NetworkManagerProtocol {

    var logInCallCount = 0
    var registerCallCount = 0
    var changeLikeCallCount = 0

    var recivedUserName = ""
    var recivedUserLogin = ""
    var recivedUserPassword = ""
    var recivadAvatarImage: UIImage?
    var recivePostId: Int16 = -1
    var reciveUserId: Int16 = -1

    let rightUserName = "Bar"
    let rightLogin = "Boo"
    let rightPassword = "Baz"

    let user = User(id: 1, name: "Bar", postsCount: 1, dateRegister: 1234, avatar: "BarAvatar")

    let post = Post(id: 0, userId: 0, timeInterval: 2345, description: "Bar",
                    photo: nil, likeUserIds: [0], viewsCount: 1, commentsCount: 0)

    let networkServiceError: NetworkServiceError = .network

    func logIn(login: String, password: String, complete: @escaping (Result<[User], NetworkServiceError>) -> Void) {
        recivedUserLogin = login
        recivedUserPassword = password
        logInCallCount += 1
        if login == rightLogin && password == rightPassword {
            complete(.success([user]))
        } else {
            complete(.failure(networkServiceError))
        }
    }

    func register(name: String, login: String, password: String, avatar: UIImage?,
                  complete: @escaping (Result<[User], NetworkServiceError>) -> Void) {
        recivedUserName = name
        recivedUserLogin = login
        recivedUserPassword = password
        recivadAvatarImage = avatar
        registerCallCount += 1
        if name == recivedUserName && login == recivedUserLogin && password == recivedUserPassword
            && recivadAvatarImage != nil {
            complete(.success([user]))
        } else {
            complete(.failure(networkServiceError))
        }
    }

    func getPosts(fromPostId: Int16?, complete: @escaping (Result<Response, NetworkServiceError>) -> Void) {
        fatalError()
    }

    func sendPost(post: SendPost, complete: @escaping (Result<Response, NetworkServiceError>) -> Void) {
        fatalError()
    }

    func updateProfile(userId: Int16, name: String, avatar: UIImage?,
                       complete: @escaping (Result<[User], NetworkServiceError>) -> Void) {
        fatalError()
    }

    func changeLike(postId: Int16, userId: Int16, complete: @escaping (Result<Post, NetworkServiceError>) -> Void) {
        recivePostId = postId
        reciveUserId = userId
        changeLikeCallCount += 1
        if postId >= 0 && userId >= 0 {
            complete(.success(post))
        } else {
            complete(.failure(networkServiceError))
        }
    }

    func removePost(postId: Int16, complete: @escaping (Result<Response, NetworkServiceError>) -> Void) {
        fatalError()
    }

    func loadComments(for postId: Int16, complete: @escaping (Result<ResponseComment, NetworkServiceError>) -> Void) {
        fatalError()
    }

    func sendComment(_ comment: String, postId: Int16, userId: Int16,
                     complete: @escaping (Result<ResponseComment, NetworkServiceError>) -> Void) {
        fatalError()
    }
}
