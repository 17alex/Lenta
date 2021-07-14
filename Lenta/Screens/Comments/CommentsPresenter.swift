//
//  CommentsPresenter.swift
//  Lenta
//
//  Created by Alex on 10.03.2021.
//

import UIKit

protocol CommentsViewOutput {
    var postsViewModel: [PostViewModel] { get }
    var commentsViewModel: [CommentViewModel] { get }
    var cellTypes: [CellType] { get }
    func viewDidLoad()
    func didPressNewCommendSendButton(comment: String)
    func didCloseButtonPress()
    func loadImages(for indexPath: IndexPath)
}

protocol CommentsInteractorOutput: AnyObject {
    func didLoadComments()
    func didSendComment(_ comments: [Comment])
    func show(message: String)
}

enum CellType {
    case post
    case comments
}

final class CommentsPresenter {

    // MARK: - Propertis

    unowned private let view: CommentsViewInput
    private let interactor: CommentsInteractorInput
    var router: CommentsRouterInput?

    private let postId: Int16
    var postsViewModel: [PostViewModel] = []
    var commentsViewModel: [CommentViewModel] = []

    let cellTypes: [CellType] = [.post, .comments]

    // MARK: - Init

    init(view: CommentsViewInput, interactor: CommentsInteractorInput, postId: Int16) {
        self.view = view
        self.postId = postId
        self.interactor = interactor
        print("CommentsPresenter init")
    }

    deinit {
        print("CommentsPresenter deinit")
    }

    // MARK: - Metods

    private func getPostViewModel(post: Post) -> PostViewModel? {
        let user = interactor.users.first(where: {$0.id == post.userId})
        return PostViewModel(post: post, user: user)
    }

    private func getCommentViewModel(comment: Comment) -> CommentViewModel? {
        let user = interactor.users.first(where: {$0.id == comment.userId})
        return CommentViewModel(comment: comment, user: user)
    }
}

// MARK: - CommentsViewOutput

extension CommentsPresenter: CommentsViewOutput {

    func loadImages(for indexPath: IndexPath) {
        switch cellTypes[indexPath.section] {
        case .post:
            let photoUrlString = postsViewModel[indexPath.row].photo?.urlString
            interactor.getImage(from: photoUrlString) { [weak self] photoData in
                guard let self = self, let photoData = photoData else { return }
                let photoImage = UIImage(data: photoData)
                self.view.set(photo: photoImage, for: indexPath)
            }

            let avatarUrlString = postsViewModel[indexPath.row].user?.avatarUrlString
            interactor.getImage(from: avatarUrlString) { [weak self] avatarData in
                guard let self = self else { return }
                var avatarImage = UIImage(named: "defaultAvatar")
                if let avatarData = avatarData {
                    avatarImage = UIImage(data: avatarData)
                }
                self.view.set(avatar: avatarImage, for: indexPath)
            }

        case .comments:
            let avatarUrlString = commentsViewModel[indexPath.row].user?.avatarUrlString
            interactor.getImage(from: avatarUrlString) { [weak self] avatarData in
                guard let self = self else { return }
                var avatarImage = UIImage(named: "defaultAvatar")
                if let avatarData = avatarData {
                    avatarImage = UIImage(data: avatarData)
                }
                self.view.set(avatar: avatarImage, for: indexPath)
            }
        }
    }

    func didCloseButtonPress() {
        router?.dismiss()
    }

    func didPressNewCommendSendButton(comment: String) {
        interactor.sendNewComment(comment)
    }

    func viewDidLoad() {
        view.showActivityIndicator()
        interactor.loadComments(by: postId)
    }
}

// MARK: - CommentsInteractorOutput

extension CommentsPresenter: CommentsInteractorOutput {

    func didSendComment(_ comments: [Comment]) {
        commentsViewModel.append(contentsOf: comments.compactMap(getCommentViewModel(comment:)))
        view.addRow()
    }

    func show(message: String) {
        view.show(message: message)
    }

    func didLoadComments() {
        postsViewModel = interactor.posts.compactMap(getPostViewModel(post:))
        commentsViewModel = interactor.comments.compactMap(getCommentViewModel(comment:))
        view.loadingEnd()
        view.reloadComments()
    }
}
