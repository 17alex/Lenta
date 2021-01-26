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
    func goLoginedUser()
    func logOutUser()
}

class LentaPresenter {
    
    unowned let view: LentaViewInput
    var interactor: LentaInteractorInput!
    var router: LentaRouterInput!
    
    init(view: LentaViewInput) {
        print("LentaPresenter init")
        self.view = view
    }
    
    deinit {
        print("LentaPresenter deinit")
    }
}

extension LentaPresenter: LentaViewOutput {
    
    func viewDidLoad() {
        interactor.loadCurrenUser()
        
        if interactor.currentUser == nil {
            view.userLoginned(false)
        } else {
            view.userLoginned(true)
        }
        
        interactor.loadPosts()
    }
    
    func logInOutButtonPress() {
        interactor.logInOutUser()
    }
    
    func newPostButtonPress() {
        guard let currUser = interactor.currentUser else { return }
        router.showEnterNewPostModule(for: currUser)
    }
    
    var postCount: Int {
        interactor.postCount
    }
    
    func reloadPosts() {
        interactor.loadPosts()
    }
    
    func postViewModel(for index: Int) -> PostViewModel {
        let post = interactor.posts[index]
        let user = try! interactor.users.first(where: {$0.id == post.userId})
        return PostViewModel(post: post, user: user!)
    }
}

extension LentaPresenter: LentaInteractorOutput {
    
    func logOutUser() {
        view.userLoginned(false)
    }
    
    func goLoginedUser() {
        router.loginUser { loginnedUser in
            self.interactor.didLoginned(loginnedUser)
            self.view.userLoginned(true)
            print("currentUser = \(loginnedUser)")
        }
    }
    
    func postsDidload() {
        view.reloadLenta()
    }
}

