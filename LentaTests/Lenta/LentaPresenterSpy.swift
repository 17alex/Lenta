//
//  LentaPresenterSpy.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 03.07.2021.
//

import Foundation
@testable import Lenta

final class LentaPresenterSpy: LentaInteractorOutput {

    var didUpdatePostCallCount = 0
    var didRemovePostCallCount = 0
    var showMessageCallCount = 0
    var didLoadNewCallCount = 0
    var didLoadFirstCallCount = 0
    var didLoadNextCallCount = 0

    var recivedIndex = -1
    var recivedError: NetworkServiceError?
    var recivedPost: Post?
    var recivedPosts: [Post] = []

    func didLoadFirst(posts: [Post]) {
        didLoadFirstCallCount += 1
        recivedPosts = posts
    }

    func didLoadNext(posts: [Post]) {
        didLoadNextCallCount += 1
        recivedPosts = posts
    }

    func didLoadNew(post: Post) {
        didLoadNewCallCount += 1
        recivedPost = post
    }

    func didUpdatePost(by index: Int) {
        didUpdatePostCallCount += 1
        recivedIndex = index
    }

    func didRemovePost(by index: Int) {
        didRemovePostCallCount += 1
        recivedIndex = index
    }

    func show(error: NetworkServiceError) {
        showMessageCallCount += 1
        recivedError = error
    }
}
