//
//  LentaPresenter.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

protocol LentaViewOutput {
    var postCount: Int { get }
    func viewDidLoad()
    func reloadPosts()
    func logInOutButtonPress()
    func newPostButtonPress()
    func postViewModel(for index: Int) -> PostViewModel
}

protocol LentaInteractorOutput: class {
    func postsDidload()
}

class LentaPresenter {
    
    unowned let view: LentaViewInput
    var interactor: LentaInteractorInput!
    var router: LentaRouterInput!
    
    var currentUser: CurrentUser?
    
    init(view: LentaViewInput) {
        print("LentaPresenter init")
        self.view = view
    }
    
    deinit {
        print("LentaPresenter deinit")
    }
}

extension LentaPresenter: LentaViewOutput {
    
    func logInOutButtonPress() {
        if currentUser == nil {
            router.loginUser { loginedUser in
                self.currentUser = loginedUser
                self.view.userLoginned(true)
//                print("currentUser = \(self.currentUser)")
            }
        } else {
            currentUser = nil
//            print("currentUser = \(currentUser)")
            view.userLoginned(false)
        }
    }
    
    func newPostButtonPress() {
        guard let currUser = currentUser else { return }
        router.showEnterNewPostModule(for: currUser)
    }
    
    var postCount: Int {
        interactor.postCount
    }
    
    func reloadPosts() {
        interactor.loadPosts()
    }
    
    func viewDidLoad() {
        currentUser = interactor.loadCurrenUser()
        
        if currentUser == nil {
            view.userLoginned(false)
        } else {
            view.userLoginned(true)
        }
        interactor.loadPosts()
    }
    
    func postViewModel(for index: Int) -> PostViewModel {
        let post = interactor.posts[index]
        let user = interactor.users[post.userId]
        return PostViewModel(post: post, user: user)
    }
}

extension LentaPresenter: LentaInteractorOutput {
    
    func postsDidload() {
        view.reloadLenta()
    }
}

