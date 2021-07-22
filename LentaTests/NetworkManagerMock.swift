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
    var removePostCallCount = 0
    var sendPostCallCount = 0
    var loadImageCallCount = 0
    var sendCommentCallCount = 0
    var loadCommentsCallCount = 0
    var updateProfileCallCount = 0
    var getPostsCallCount = 0

    var recivedUserName = ""
    var recivedUserLogin = ""
    var recivedUserPassword = ""
    var recivedUrlString: String?
    var recivadAvatarImageData: Data?
    var recivePostId: Int16 = -1
    var reciveUserId: Int16 = -1
    var recivedSendPost: SendPost?
    let sendedData = Data()
    var recivedNewComment = ""
    var recivedFromPostId: Int16?

    let rightUserName = "Bar"
    let rightLogin = "Boo"
    let rightPassword = "Baz"

    let user = User(id: 1, name: "Bar", postsCount: 1, dateRegister: 1234, avatar: "BarAvatar")

    let post = Post(id: 0, userId: 0, timeInterval: 2345, description: "Bar",
                    photo: nil, likeUserIds: [0], viewsCount: 1, commentsCount: 0)
    let comment = Comment(id: 0, timeInterval: 0, postId: 0, userId: 0, text: "text")
    
    lazy var response = Response(posts: [post], users: [user])

    lazy var responseComment = ResponseComment(posts: [post], comments: [comment], users: [user])

    let networkServiceError: NetworkServiceError = .network

    func login(login: String, password: String, completion: @escaping (Result<[User], NetworkServiceError>) -> Void) {
        recivedUserLogin = login
        recivedUserPassword = password
        logInCallCount += 1
        if login == rightLogin && password == rightPassword {
            completion(.success([user]))
        } else {
            completion(.failure(networkServiceError))
        }
    }

    func register(name: String, login: String, password: String, avatar: Data?,
                  completion: @escaping (Result<[User], NetworkServiceError>) -> Void) {
        recivedUserName = name
        recivedUserLogin = login
        recivedUserPassword = password
        recivadAvatarImageData = avatar
        registerCallCount += 1
        if name == recivedUserName && login == recivedUserLogin && password == recivedUserPassword
            && recivadAvatarImageData != nil {
            completion(.success([user]))
        } else {
            completion(.failure(networkServiceError))
        }
    }

    func getPosts(fromPostId: Int16?, completion: @escaping (Result<Response, NetworkServiceError>) -> Void) {
        getPostsCallCount += 1
        recivedFromPostId = fromPostId
        completion(.success(response))
    }

    func sendPost(post: SendPost, completion: @escaping (Result<Response, NetworkServiceError>) -> Void) {
        sendPostCallCount += 1
        recivedSendPost = post
        if post.description == "Baz" {
            let returnPost = Post(id: 0, userId: 0, timeInterval: 0, description: post.description, photo: nil, likeUserIds: [], viewsCount: 0, commentsCount: 0)
            let returnResponse = Response(posts: [returnPost], users: [user])
            completion(.success(returnResponse))
        } else {
            completion(.failure(networkServiceError))
        }
    }

    func updateProfile(userId: Int16, name: String, avatar: Data?,
                       completion: @escaping (Result<[User], NetworkServiceError>) -> Void) {
        updateProfileCallCount += 1
        reciveUserId = userId
        recivedUserName = name
        recivadAvatarImageData = avatar
        if reciveUserId == 0 {
            completion(.success([user]))
        } else {
            completion(.failure(networkServiceError))
        }
    }

    func changeLike(postId: Int16, userId: Int16, completion: @escaping (Result<Post, NetworkServiceError>) -> Void) {
        recivePostId = postId
        reciveUserId = userId
        changeLikeCallCount += 1
        if postId == 0 && userId == 0 {
            completion(.success(post))
        } else {
            completion(.failure(networkServiceError))
        }
    }

    func removePost(postId: Int16, completion: @escaping (Result<Response, NetworkServiceError>) -> Void) {
        recivePostId = postId
        removePostCallCount += 1
        if postId == 0 {
            completion(.success(response))
        } else {
            completion(.failure(networkServiceError))
        }
    }

    func loadComments(for postId: Int16, completion: @escaping (Result<ResponseComment, NetworkServiceError>) -> Void) {
        loadCommentsCallCount += 1
        recivePostId = postId
        if postId == 0 {
            completion(.success(responseComment))
        } else {
            completion(.failure(networkServiceError))
        }
    }

    func sendComment(_ comment: String, postId: Int16, userId: Int16,
                     completion: @escaping (Result<ResponseComment, NetworkServiceError>) -> Void) {
        recivedNewComment = comment
        sendCommentCallCount += 1
        if postId == 0 {
            completion(.success(responseComment))
        } else {
            completion(.failure(networkServiceError))
        }
    }

    func loadImage(from urlString: String?, completion: @escaping (Data?) -> Void) {
        recivedUrlString = urlString
        loadImageCallCount += 1
        completion(sendedData)
    }
}
