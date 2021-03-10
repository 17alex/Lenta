//
//  CommentsInteractor.swift
//  Lenta
//
//  Created by Alex on 10.03.2021.
//

import Foundation

protocol CommentsInteractorInput {
    var comments: [Comment] { get }
    var users: [User] { get }
    func loadComments(by postId: Int)
}

class CommentsInteractor {
    
    unowned let presenter: CommentsInteractorOutput
    var networkManager: NetworkManagerProtocol!
    
    var comments: [Comment] = []
    var users: [User] = []
    
    init(presenter: CommentsInteractorOutput) {
        print("CommentsInteractor init")
        self.presenter = presenter
    }
    
    deinit { print("CommentsInteractor deinit") }
        
}

//MARK: - CommentsInteractorInput

extension CommentsInteractor: CommentsInteractorInput {
    
    func loadComments(by postId: Int) {
        networkManager.loadComments(by: postId) { result in
            switch result {
            case .failure(let error):
                self.presenter.show(message: error.localizedDescription)
            case .success(let responseComment):
                self.comments = responseComment.comments
                self.users = responseComment.users
                self.presenter.didLoadComments()
            }
        }
    }
    
}
