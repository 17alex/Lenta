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
    func loadComments(by postId: Int)
    func sendNewComment(_ comment: String)
}

class CommentsInteractor {
    
    unowned let presenter: CommentsInteractorOutput
    var networkManager: NetworkManagerProtocol!
    var storeManager: StoreManagerProtocol!
    
    var posts: [Post] = []
    var comments: [Comment] = []
    var users: Set<User> = []
    var currentUser: CurrentUser?
    
    init(presenter: CommentsInteractorOutput) {
        print("CommentsInteractor init")
        self.presenter = presenter
    }
    
    deinit { print("CommentsInteractor deinit") }
        
}

//MARK: - CommentsInteractorInput

extension CommentsInteractor: CommentsInteractorInput {
    
    func sendNewComment(_ comment: String) {
        currentUser = storeManager.getCurrenUser()
        guard currentUser != nil else {
            presenter.show(message: "User not loginned")
            return
        }
        networkManager.sendComment(comment, postId: posts.first!.id, userId: currentUser!.id) { (result) in
            switch result {
            case .failure(let error):
                self.presenter.show(message: error.localizedDescription)
            case .success(let responseComment):
            self.comments.append(contentsOf: responseComment.comments)
            self.users = self.users.union(responseComment.users)
            self.presenter.didSendComment(responseComment.comments)
            }
        }
    }
    
    func loadComments(by postId: Int) {
        networkManager.loadComments(by: postId) { result in
            switch result {
            case .failure(let error):
                self.presenter.show(message: error.localizedDescription)
            case .success(let responseComment):
                self.posts = responseComment.posts
                self.comments = responseComment.comments
                self.users = Set(responseComment.users)
                self.presenter.didLoadComments()
            }
        }
    }
    
}
