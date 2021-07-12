//
//  CommentsInteractor.swift
//  Lenta
//
//  Created by Alex on 10.03.2021.
//

import Foundation

protocol CommentsInteractorInput {
    var posts: [Post] { get }
    var comments: [Comment] { get }
    var users: Set<User> { get }
    func loadComments(by postId: Int16)
    func sendNewComment(_ comment: String)
}

final class CommentsInteractor {

    // MARK: - Propertis

    weak var presenter: CommentsInteractorOutput?
    var networkManager: NetworkManagerProtocol?
    var storeManager: StoreManagerProtocol?

    var posts: [Post] = []
    var comments: [Comment] = []
    var users: Set<User> = []
    private var currentUser: User?

    // MARK: - Init

    init() {
        print("CommentsInteractor init")
    }

    deinit {
        print("CommentsInteractor deinit")
    }
}

// MARK: - CommentsInteractorInput

extension CommentsInteractor: CommentsInteractorInput {

    func sendNewComment(_ comment: String) {
        guard let currentUser = storeManager?.getCurrenUser() else {
            presenter?.show(message: "User not loginned")
            return
        }

        networkManager?.sendComment(comment, postId: posts[0].id, userId: currentUser.id) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let serviceError):
                strongSelf.presenter?.show(message: serviceError.rawValue)
            case .success(let responseComment):
                strongSelf.comments.append(contentsOf: responseComment.comments)
                strongSelf.users = strongSelf.users.union(responseComment.users)
                strongSelf.presenter?.didSendComment(responseComment.comments)
            }
        }
    }

    func loadComments(by postId: Int16) {
        networkManager?.loadComments(for: postId) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let serviceError):
                strongSelf.presenter?.show(message: serviceError.rawValue)
            case .success(let responseComment):
                strongSelf.posts = responseComment.posts
                strongSelf.comments = responseComment.comments
                strongSelf.users = Set(responseComment.users)
                strongSelf.presenter?.didLoadComments()
            }
        }
    }
}
