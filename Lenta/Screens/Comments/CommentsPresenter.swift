//
//  CommentsPresenter.swift
//  Lenta
//
//  Created by Alex on 10.03.2021.
//

import Foundation

protocol CommentsViewOutput {
    var postsViewModel: [PostViewModel] { get }
    var commentsViewModel: [CommentViewModel] { get }
    var cellTypes: [CellType] { get }
    func viewDidLoad()
    func didPressNewCommendSendButton(comment: String)
    func didCloseButtonPress()
}

protocol CommentsInteractorOutput: class {
    func didLoadComments()
    func didSendComment(_ comments: [Comment])
    func show(message: String)
}

enum CellType {
    case post
    case comments
}

class CommentsPresenter {
    
    unowned let view: CommentsViewInput
    var interactor: CommentsInteractorInput!
    var router: CommentsRouterInput!
    
    let postId: Int
    var postsViewModel: [PostViewModel] = []
    var commentsViewModel: [CommentViewModel] = []
    
    let cellTypes: [CellType] = [.post, .comments]
    
    init(view: CommentsViewInput, postId: Int) {
        self.view = view
        self.postId = postId
        print("CommentsPresenter init")
    }
    
    deinit {
        print("CommentsPresenter deinit")
    }
    
    private func getPostViewModel(post: Post) -> PostViewModel {
        let user = interactor.users.first(where: {$0.id == post.userId})
        return PostViewModel(post: post, user: user!, currenUser: nil)
    }
    
    private func getCommentViewModel(comment: Comment) -> CommentViewModel {
        let user = interactor.users.first(where: {$0.id == comment.userId})
        return CommentViewModel(comment: comment, user: user!)
    }
}

extension CommentsPresenter: CommentsViewOutput {
    
    func didCloseButtonPress() {
        router.dismiss()
    }
    
    func didPressNewCommendSendButton(comment: String) {
        interactor.sendNewComment(comment)
    }
    
    func viewDidLoad() {
        view.loadingStarted()
        interactor.loadComments(by: postId)
    }
}

extension CommentsPresenter: CommentsInteractorOutput {
    
    func didSendComment(_ comments: [Comment]) {
        commentsViewModel.append(contentsOf: comments.map(getCommentViewModel(comment:)))
        view.addRow()
    }
    
    func show(message: String) {
        view.show(message: message)
    }
    
    func didLoadComments() {
        postsViewModel = interactor.posts.map(getPostViewModel(post:))
        commentsViewModel = interactor.comments.map(getCommentViewModel(comment:))
        view.loadingEnd()
        view.reloadComments()
    }
}
