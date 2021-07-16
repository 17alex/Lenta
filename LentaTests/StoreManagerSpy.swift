//
//  storageManagerSpy.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 03.07.2021.
//

import Foundation
@testable import Lenta

final class storageManagerSpy: StorageManagerProtocol {

    var savedUser: User?
    let sendUser = User(id: 1, name: "Baz", postsCount: 5, dateRegister: 1111, avatar: "sendAvatar")

    var saveUserCallCount = 0
    var getCurrenUserCallCount = 0

    func getCurrenUser() -> User? {
        getCurrenUserCallCount += 1
        return sendUser
    }

    func save(user: User?) {
        savedUser = user
        saveUserCallCount += 1
    }

    func load(complete: @escaping ([Post], [User]) -> Void) {
        fatalError()
    }

    func save(posts: [Post]) {
        fatalError()
    }

    func save(users: [User]) {
        fatalError()
    }

    func append(posts: [Post]) {
        fatalError()
    }
}
