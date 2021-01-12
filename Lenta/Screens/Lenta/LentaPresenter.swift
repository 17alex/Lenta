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
    func postViewModel(for index: Int) -> PostViewModel
}

protocol LentaInteractorOutput: class {
    func postsDidload()
}

class LentaPresenter {
    
    unowned let view: LentaViewInput
    var interactor: LentaInteractorInput!
    var router: LentaRouterInput!
    
    init(view: LentaViewInput) {
        print("LentaPresenter init")
        self.view = view
    }
    
    deinit { print("LentaPresenter deinit") }
    
}

extension LentaPresenter: LentaViewOutput {
    
    var postCount: Int {
        interactor.postCount
    }
    
    func viewDidLoad() {
        interactor.loadPosts()
    }
    
    func postViewModel(for index: Int) -> PostViewModel {
        return PostViewModel(post: interactor.posts[index])
    }
}

extension LentaPresenter: LentaInteractorOutput {
    
    func postsDidload() {
        view.reloadLenta()
    }
}
