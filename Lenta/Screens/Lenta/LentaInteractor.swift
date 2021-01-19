//
//  LentaInteractor.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

protocol LentaInteractorInput {
    var posts: [Post] { get }
    var users: [User] { get }
    var postCount: Int { get }
    func loadPosts()
    func loadCurrenUser() -> CurrentUser?
}

class LentaInteractor {
    
    unowned let presenter: LentaInteractorOutput
    var networkManager: NetworkManagerProtocol!
    var storeManager: StoreManagerProtocol!
    
    init(presenter: LentaInteractorOutput) {
        print("LentaInteractor init")
        self.presenter = presenter
    }
    
    deinit { print("LentaInteractor deinit") }
    
    var posts: [Post] = []
    var users: [User] = []
    var postCount: Int {
        posts.count
    }
}

extension LentaInteractor: LentaInteractorInput {
    
    func loadCurrenUser() -> CurrentUser? {
        return storeManager.getCurrenUser()
    }
    
    func loadPosts() {
        networkManager.getPosts { (response) in
            switch response {
            case .failure(let error):
                print("error: \(error)")
            case .success(let resp):
                self.posts = resp.posts
                self.users = resp.users
                self.presenter.postsDidload()
            }
        }
    }
}
