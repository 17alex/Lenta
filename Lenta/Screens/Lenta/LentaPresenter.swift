//
//  LentaPresenter.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

protocol LentaViewOutput {
    var postViewModels: [PostViewModel] { get }
    func viewDidLoad()
    func viewWillAppear()
    func pullToRefresh()
    func menuButtonPress()
    func newPostButtonPress()
    func changeLike(postIndex: Int)
    func changeNumberOfLineDescription(for postIndex: Int)
}

protocol LentaInteractorOutput: class {
    func postsDidLoad()
    func postReload(at index: Int)
    func postsLoadFail(message: String)
}

class LentaPresenter {
    
    unowned let view: LentaViewInput
    var interactor: LentaInteractorInput!
    var router: LentaRouterInput!
    
    var postViewModels: [PostViewModel] = []
    
    init(view: LentaViewInput) {
        print("LentaPresenter init")
        self.view = view
    }
    
    deinit {
        print("LentaPresenter deinit")
    }
}

extension LentaPresenter: LentaViewOutput {
    
    func changeLike(postIndex: Int) {
        interactor.changeLike(postIndex: postIndex)
    }
    
    func changeNumberOfLineDescription(for postIndex: Int) {
        postViewModels[postIndex].numberOfLineDescription = 0
    }
    
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
    
    func pullToRefresh() {
        interactor.loadPosts()
    }
}

extension LentaPresenter: LentaInteractorOutput {
    
    func postReload(at index: Int) {
        postViewModels[index].update(with: interactor.posts[index])
        view.reloadPost(index: index)
    }
    
    func postsLoadFail(message: String) {
        view.show(message: message)
    }
    
    func postsDidLoad() {
        postViewModels = []
        for index in 0..<interactor.posts.count {
            let post = interactor.posts[index]
            let user = try! interactor.users.first(where: {$0.id == post.userId})
            postViewModels.append(PostViewModel(post: post, user: user!))
        }
        
        view.reloadLenta()
    }
}

