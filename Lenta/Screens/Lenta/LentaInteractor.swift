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
    var users: Set<User> { get }
    func loadPosts()
    func addNewPost(response: Response)
    func loadNextPosts()
    func deletePost(by index: Int)
    func changeLike(by index: Int)
    func getCurrenUser()
}

class LentaInteractor {
    
    unowned let presenter: LentaInteractorOutput
    var networkManager: NetworkManagerProtocol!
    var storeManager: StoreManagerProtocol!
    
    var currentUser: CurrentUser?
    var posts: [Post] = []
    var users: Set<User> = []
    var isLoadingPosts = false
    var isEndingPosts = false
    
    init(presenter: LentaInteractorOutput) {
        print("LentaInteractor init")
        self.presenter = presenter
    }
    
    deinit { print("LentaInteractor deinit") }
    
}

//MARK: - LentaInteractorInput

extension LentaInteractor: LentaInteractorInput {
    
    func addNewPost(response: Response) {
        if let post = response.posts.first {
            posts.insert(post, at: 0)
            users = self.users.union(response.users)
            let user = response.users.first!
            let currentUser = CurrentUser(id: user.id, name: user.name, postsCount: user.postsCount, dateRegister: user.dateRegister, avatar: user.avatar)
            storeManager.save(currentUser)
            presenter.didLoadNew(post: post)
        }
    }
    
    func deletePost(by index: Int) {
        networkManager.removePost(postId: posts[index].id) { (result) in
            switch result {
            case .failure(let error):
                self.presenter.show(message: error.localizedDescription)
            case .success(let response):
                guard let deletePost = response.posts.first else { return }
                if let deleteIndex = self.posts.firstIndex(where: { $0.id == deletePost.id })  {
                    self.posts.remove(at: deleteIndex)
                    self.presenter.didRemovePost(by: deleteIndex)
                }
                let user = response.users.first!
                let currentUser = CurrentUser(id: user.id, name: user.name, postsCount: user.postsCount, dateRegister: user.dateRegister, avatar: user.avatar)
                self.storeManager.save(currentUser)
            }
        }
    }
    
    func loadNextPosts() {
        guard !isLoadingPosts && !isEndingPosts else { return }
        isLoadingPosts = true
        let lastPostId = posts[posts.count - 1].id
        networkManager.getPosts(fromPostId: lastPostId) { (result) in
            self.isLoadingPosts = false
            switch result {
            case .failure(let error):
                self.presenter.show(message: error.localizedDescription)
            case .success(let response):
                self.posts.append(contentsOf: response.posts)
                self.users = self.users.union(response.users)
                if response.posts.count == 0 {
                    self.isEndingPosts = true
                } else {
                    self.presenter.didLoadNext(posts: response.posts)
                }
            }
        }
    }
    
    func loadPosts() {
        guard !isLoadingPosts else { return }
        isLoadingPosts = true
        isEndingPosts = false
        networkManager.getPosts(fromPostId: nil) { (result) in
            self.isLoadingPosts = false
            switch result {
            case .failure(let error):
                self.presenter.show(message: error.localizedDescription)
            case .success(let response):
                self.posts = response.posts
                self.users = Set(response.users)
                self.presenter.didLoadFirst(posts: response.posts)
            }
        }
    }
    
    func changeLike(by index: Int) {
        guard let currentUser = currentUser else { return }
        let postId = posts[index].id
        networkManager.changeLike(postId: postId, userId: currentUser.id) { (result) in
            switch result {
            case .failure(let error):
                self.presenter.show(message: error.localizedDescription)
            case .success(let post):
                self.posts[index] = post
                self.presenter.didUpdatePost(by: index)
            }
        }
    }
    
    func getCurrenUser() {
        currentUser = storeManager.getCurrenUser()
    }
}
