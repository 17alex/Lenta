//
//  CommentsPresenter.swift
//  Lenta
//
//  Created by Alex on 10.03.2021.
//

import Foundation

protocol CommentsViewOutput {
    var commentsViewModel: [CommentViewModel] { get }
    func viewDidLoad()
}

protocol CommentsInteractorOutput: class {
    func didLoadComments()
    func show(message: String)
}

class CommentsPresenter {
    
    unowned let view: CommentsViewInput
    var interactor: CommentsInteractorInput!
    var router: CommentsRouterInput!
    
    let postId: Int
    var commentsViewModel: [CommentViewModel] = []
    
    init(view: CommentsViewInput, postId: Int) {
        self.view = view
        self.postId = postId
        print("CommentsPresenter init")
    }
    
    deinit {
        print("CommentsPresenter deinit")
    }
    
    private func getCommentViewModel(comment: Comment) -> CommentViewModel {
        let user = interactor.users.first(where: {$0.id == comment.userId})
        return CommentViewModel(comment: comment, user: user!)
    }
}

extension CommentsPresenter: CommentsViewOutput {
    
    func viewDidLoad() {
        view.loadingStarted()
        interactor.loadComments(by: postId)
    }
}

extension CommentsPresenter: CommentsInteractorOutput {
    
    func show(message: String) {
        view.show(message: message)
    }
    
    func didLoadComments() {
        commentsViewModel = interactor.comments.map(getCommentViewModel(comment:))
        view.loadingEnd()
        view.reloadComments()
    }
}
