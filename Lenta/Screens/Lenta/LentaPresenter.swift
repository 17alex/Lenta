//
//  LentaPresenter.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol LentaViewOutput {
    var postsViewModel: [PostViewModel] { get }
    func viewDidLoad()
    func viewWillAppear()
    func didPressToRefresh()
    func didPressDeletePost(by index: Int)
    func didPressNewPost()
    func didPressMenu(by index: Int)
    func didPressComments(by index: Int)
    func didPressLike(postIndex: Int)
    func willDisplayCell(by index: Int)
    func didTapAvatar(by index: Int)
}

protocol LentaInteractorOutput: AnyObject {
    func didLoadFirst(posts: [Post])
    func didLoadNext(posts: [Post])
    func didLoadNew(post: Post)
    func didUpdatePost(by index: Int)
    func didRemovePost(by index: Int)
    func show(message: String)
}

final class LentaPresenter {

    unowned private let view: LentaViewInput
    private let interactor: LentaInteractorInput
    private let router: LentaRouterInput

    var postsViewModel: [PostViewModel] = []

    init(view: LentaViewInput, interactor: LentaInteractorInput, router: LentaRouterInput) {
        self.view = view
        self.router = router
        self.interactor = interactor
        print("LentaPresenter init")
    }

    deinit {
        print("LentaPresenter deinit")
    }

    private func getPostViewModel(post: Post) -> PostViewModel {
        let user = interactor.users.first(where: {$0.id == post.userId})
        return PostViewModel(post: post, user: user, currenUser: interactor.currentUser)
    }
}

// MARK: - LentaViewOutput

extension LentaPresenter: LentaViewOutput {

    func didTapAvatar(by index: Int) {
        guard let userViewModel = postsViewModel[index].user else { return }
        router.showUserInfoModule(user: userViewModel)
    }

    func didPressComments(by index: Int) {
        let postId = interactor.posts[index].id
        router.showCommentsModule(by: postId)
    }

    func didPressMenu(by index: Int) {
        var isPostOwner = false
        if let currentUser = interactor.currentUser,
           interactor.posts[index].userId == currentUser.id {
            isPostOwner = true
        }
        view.showMenu(byPostIndex: index, isPostOwner: isPostOwner)
    }

    func didPressDeletePost(by index: Int) {
        interactor.deletePost(by: index)
    }

    func willDisplayCell(by index: Int) {
        interactor.getImage(from: postsViewModel[index].photo?.urlString) { [weak self] photoData in
            guard let self = self, let photoData = photoData else { return }
            let photoImage = UIImage(data: photoData)
            self.view.set(photo: photoImage, for: index)
        }

        interactor.getImage(from: postsViewModel[index].user?.avatarUrlString) { [weak self] avatarData in
            guard let self = self else { return }
            var avatarImage = UIImage(named: "defaultAvatar")
            if let avatarData = avatarData {
                avatarImage = UIImage(data: avatarData)
            }
            self.view.set(avatar: avatarImage, for: index)
        }

        let remainingPostsCountForPreload = 4
        guard index >= interactor.posts.count - remainingPostsCountForPreload else { return }
        interactor.loadNextPosts()
    }

    func didPressLike(postIndex: Int) {
        interactor.changeLike(by: postIndex)
    }

    func viewDidLoad() {
        interactor.loadFromStore()
        view.loadingStarted()
        interactor.loadPosts()
    }

    func viewWillAppear() {
        interactor.getCurrenUser()
        postsViewModel = interactor.posts.compactMap(getPostViewModel(post:))
        view.reloadLenta()
        view.userLoginned(interactor.currentUser != nil)
    }

    func didPressNewPost() {
        router.showNewPostModule { [weak self] response in
            self?.interactor.addNewPost(response: response)
        }
    }

    func didPressToRefresh() {
        interactor.loadPosts()
    }
}

// MARK: - LentaInteractorOutput

extension LentaPresenter: LentaInteractorOutput {

    func didLoadNew(post: Post) {
        postsViewModel.insert(getPostViewModel(post: post), at: 0)
        self.view.insertPost(by: 0)
    }

    func didRemovePost(by index: Int) {
        postsViewModel.remove(at: index)
        view.removePost(by: index)
    }

    func didLoadFirst(posts: [Post]) {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.postsViewModel = posts.map(self.getPostViewModel(post:))
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view.loadingEnd()
            self.view.reloadLenta()
        }
    }

    func didLoadNext(posts: [Post]) {
        var startIndex = 0
        var endIndex = 0
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            startIndex = self.postsViewModel.count
            self.postsViewModel.append(contentsOf: posts.map(self.getPostViewModel(post:)))
            endIndex = self.postsViewModel.count
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view.insertPosts(fromIndex: startIndex, toIndex: endIndex)
        }
    }

    func didUpdatePost(by index: Int) {
        postsViewModel[index] = getPostViewModel(post: interactor.posts[index])
        view.reloadPost(by: index)
    }

    func show(message: String) {
        view.loadingEnd()
        view.show(message: message)
    }
}
