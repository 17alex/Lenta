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

    var recivedIndex = -1
    var recivedError: NetworkServiceError?

    func didLoadFirst(posts: [Post]) {
        fatalError()
    }

    func didLoadNext(posts: [Post]) {
        fatalError()
    }

    func didLoadNew(post: Post) {
        fatalError()
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
