//
//  CommentsPresenterSpy.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 22.07.2021.
//

import Foundation
@testable import Lenta

final class CommentsPresenterSpy: CommentsInteractorOutput {

    var reciverError: NetworkServiceError?
    var recivedComments: [Comment] = []

    var showCallCount = 0
    var didLoadCommentsCallCount = 0
    var didSendCommentCallCount = 0

    func didLoadComments() {
        didLoadCommentsCallCount += 1
    }

    func didSendComment(_ comments: [Comment]) {
        didSendCommentCallCount += 1
        recivedComments = comments
    }

    func show(error: NetworkServiceError) {
        showCallCount += 1
        reciverError = error
    }


}
