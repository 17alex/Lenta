//
//  LentaPresenter.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

protocol LentaViewOutput {
    var postsViewModel: [PostViewModel] { get }
    func viewDidLoad()
    func viewWillAppear()
    func didPressToRefresh()
    func didPressDeletePost(by index: Int)
    func didPressNewPost()
    func didPressMenu(by index: Int)
    func didPressLike(postIndex: Int)
    func didPressMore(postIndex: Int)
    func willDisplayCell(by index: Int)
}

protocol LentaInteractorOutput: class {
    func didLoadFirst(posts: [Post])
    func didLoadNext(posts: [Post])
    func didLoadNew(post: Post)
    func didUpdatePost(by index: Int)
    func didRemovePost(by index: Int)
    func show(message: String)
}

final class LentaPresenter {
    
    unowned let view: LentaViewInput
    var interactor: LentaInteractorInput!
    var router: LentaRouterInput!
    
    var postsViewModel: [PostViewModel] = []
    
    init(view: LentaViewInput) {
        self.view = view
        print("LentaPresenter init")
    }
    
    deinit {
        print("LentaPresenter deinit")
    }
    
    private func getPostViewModel(post: Post) -> PostViewModel {
        let user = interactor.users.first(where: {$0.id == post.userId})
        return PostViewModel(post: post, user: user!, currenUser: interactor.currentUser)
    }
}

//MARK: - LentaViewOutput

extension LentaPresenter: LentaViewOutput {
    
    func didPressMenu(by index: Int) {
        var isOwnerPost = false
        if let currentUser = interactor.currentUser,
           interactor.posts[index].userId == currentUser.id {
            isOwnerPost = true
        }
        view.showMenu(byPostIndex: index, isOwner: isOwnerPost)
    }

    func didPressDeletePost(by index: Int) {
        interactor.deletePost(by: index)
    }
    
    func willDisplayCell(by index: Int) {
        guard index >= interactor.posts.count - 4 else { return }
        interactor.loadNextPosts()
    }
    
    func didPressLike(postIndex: Int) {
        interactor.changeLike(by: postIndex)
    }
    
    func didPressMore(postIndex: Int) {
        postsViewModel[postIndex].description.isExpand = true
        view.reloadPost(by: postIndex)
    }
    
    func viewDidLoad() {
        view.loadingStarted()
        interactor.loadPosts()
    }
    
    func viewWillAppear() {
        interactor.getCurrenUser()
        postsViewModel = interactor.posts.map(getPostViewModel(post:))
        view.reloadLenta()
        view.userLoginned(interactor.currentUser != nil)
    }
    
    func didPressNewPost() {
        router.showNewPostModule { response in
            self.interactor.addNewPost(response: response)
        }
    }
    
    func didPressToRefresh() {
        interactor.loadPosts()
    }
}

//MARK: - LentaInteractorOutput

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
        postsViewModel = posts.map(getPostViewModel(post:))
        view.loadingEnd()
        view.reloadLenta()
    }
    
    func didLoadNext(posts: [Post]) {
        let startIndex = postsViewModel.count
        postsViewModel.append(contentsOf: posts.map(getPostViewModel(post:)))
        let endIndex = postsViewModel.count
        view.insertPosts(fromIndex: startIndex, toIndex: endIndex)
    }
    
    func didUpdatePost(by index: Int) {
        postsViewModel[index] = getPostViewModel(post: interactor.posts[index])
        view.reloadPost(by: index)
    }
    
    func show(message: String) {
        view.show(message: message)
    }
    
}

