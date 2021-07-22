//
//  storageManagerSpy.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 03.07.2021.
//

import Foundation
@testable import Lenta

final class StorageManagerSpy: StorageManagerProtocol {

    var savedUser: User?
    var savedUsers: [User] = []
    var savedPosts: [Post] = []
    
    let sendedUser = User(id: 0, name: "Baz", postsCount: 0, dateRegister: 0, avatar: "sendAvatar")
    
    let sendedPost = Post(id: 0, userId: 0, timeInterval: 0, description: "", photo: nil, likeUserIds: [], viewsCount: 0, commentsCount: 0)

    var saveUserCallCount = 0
    var getCurrenUserCallCount = 0
    var savePostsCallCount = 0
    var saveUsersCallCount = 0
    var loadCallCount = 0
    var appendCallCount = 0

    func getCurrenUser() -> User? {
        getCurrenUserCallCount += 1
        return sendedUser
    }

    func save(user: User?) {
        savedUser = user
        saveUserCallCount += 1
    }

    func load(completion: @escaping ([Post], [User]) -> Void) {
        loadCallCount += 1
        completion([sendedPost], [sendedUser])
    }

    func save(posts: [Post]) {
        savePostsCallCount += 1
        savedPosts = posts
    }

    func save(users: [User]) {
        saveUsersCallCount += 1
        savedUsers = users
    }

    func append(posts: [Post]) {
        appendCallCount += 1
        savedPosts = posts
    }
}
