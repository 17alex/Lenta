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
    func getImage(from urlString: String?, complete: @escaping (Data?) -> Void)
}

final class CommentsInteractor {

    // MARK: - Properties

    weak var presenter: CommentsInteractorOutput?
    var networkManager: NetworkManagerProtocol?
    var storageManager: StorageManagerProtocol?

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

    func getImage(from urlString: String?, complete: @escaping (Data?) -> Void) {
        networkManager?.loadImage(from: urlString, completion: complete)
    }

    func sendNewComment(_ comment: String) {
        guard let currentUser = storageManager?.getCurrenUser() else { return }
        networkManager?.sendComment(comment, postId: posts[0].id, userId: currentUser.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let serviceError):
                self.presenter?.show(error: serviceError)
            case .success(let responseComment):
                self.comments.append(contentsOf: responseComment.comments)
                self.users = self.users.union(responseComment.users)
                self.presenter?.didSendComment(responseComment.comments)
            }
        }
    }

    func loadComments(by postId: Int16) {
        networkManager?.loadComments(for: postId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let serviceError):
                self.presenter?.show(error: serviceError)
            case .success(let responseComment):
                self.posts = responseComment.posts
                self.comments = responseComment.comments
                self.users = Set(responseComment.users)
                self.presenter?.didLoadComments()
            }
        }
    }
}
