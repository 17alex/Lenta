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
    var users: [Int16: User] { get }
    func loadComments(byPostId postId: Int16)
    func sendNewComment(_ comment: String)
    func getImage(from urlString: String?, completion: @escaping (Data?) -> Void)
}

final class CommentsInteractor {

    // MARK: - Properties

    weak var presenter: CommentsInteractorOutput?
    var networkManager: NetworkManagerProtocol?
    var storageManager: StorageManagerProtocol?

    var posts: [Post] = []
    var comments: [Comment] = []
    var users: [Int16: User] = [:]
    var currentUser: User?

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

    func getImage(from urlString: String?, completion: @escaping (Data?) -> Void) {
        networkManager?.loadImage(from: urlString, completion: completion)
    }

    func sendNewComment(_ comment: String) {
        guard let currentUser = storageManager?.getCurrenUserFromUserDefaults() else { return }
        networkManager?.sendComment(comment, postId: posts[0].id, userId: currentUser.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let serviceError):
                self.presenter?.show(error: serviceError)
            case .success(let responseComment):
                self.comments.append(contentsOf: responseComment.comments)
                responseComment.users.forEach { responseUser in
                    self.users.updateValue(responseUser, forKey: responseUser.id)
                }
                self.presenter?.didSendComment(responseComment.comments)
            }
        }
    }

    func loadComments(byPostId postId: Int16) {
        networkManager?.loadComments(for: postId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let serviceError):
                self.presenter?.show(error: serviceError)
            case .success(let responseComment):
                self.posts = responseComment.posts
                self.comments = responseComment.comments
                self.users = [:]
                responseComment.users.forEach { responseUser in
                    self.users.updateValue(responseUser, forKey: responseUser.id)
                }
                self.presenter?.didLoadComments()
            }
        }
    }
}
