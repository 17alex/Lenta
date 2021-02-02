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
    func viewWillAppear()
    func pullToRefresh()
    func menuButtonPress()
    func newPostButtonPress()
    func postViewModel(for index: Int) -> PostViewModel
}

protocol LentaInteractorOutput: class {
    func postsDidLoad()
    func postsLoadFail(message: String)
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
        interactor.loadPosts()
    }
    
    func viewWillAppear() {
        interactor.loadCurrenUser()
        view.userLoginned(interactor.currentUser != nil)
    }
    
    func menuButtonPress() {
        router.showMenuModule()
    }
    
    func newPostButtonPress() {
        router.showEnterNewPostModule()
    }
    
    var postCount: Int {
        interactor.postCount
    }
    
    func pullToRefresh() {
        interactor.loadPosts()
    }
    
    func postViewModel(for index: Int) -> PostViewModel {
        let post = interactor.posts[index]
        let user = try! interactor.users.first(where: {$0.id == post.userId})
        return PostViewModel(post: post, user: user!)
    }
}

extension LentaPresenter: LentaInteractorOutput {
    
    func postsLoadFail(message: String) {
        view.show(message: message)
    }
    
    func postsDidLoad() {
        view.reloadLenta()
    }
}

