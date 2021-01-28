//
//  LentaInteractor.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

protocol LentaInteractorInput {
    var currentUser: CurrentUser? { get }
    var posts: [Post] { get }
    var users: [User] { get }
    var postCount: Int { get }
    func loadPosts()
    func loadCurrenUser()
    func logInOutUser()
    func didLoginned(_ user: CurrentUser)
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
    
    var currentUser: CurrentUser?
    var posts: [Post] = []
    var users: [User] = []
    var postCount: Int {
        posts.count
    }
}

extension LentaInteractor: LentaInteractorInput {
    
    func didLoginned(_ user: CurrentUser) {
        currentUser = user
        storeManager.save(currentUser)
    }
    
    func logInOutUser() {
        if currentUser == nil {
//            presenter.goLoginedUser()
        } else {
            currentUser = nil
            storeManager.save(currentUser)
            presenter.logOutUser()
        }
    }
    
    func loadCurrenUser() {
        currentUser = storeManager.getCurrenUser()
        
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
