//
//  LentaInteractor.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

protocol LentaInteractorInput {
    var currentUser: User? { get }
    var posts: [Post] { get }
    var users: Set<User> { get }
    func loadFromStore()
    func loadPosts()
    func loadNextPosts()
    func addNewPost(response: Response)
    func deletePost(by index: Int)
    func changeLike(by index: Int)
    func getCurrenUser()
}

final class LentaInteractor {
    
    unowned let presenter: LentaInteractorOutput
    var networkManager: NetworkManagerProtocol!
    var storeManager: StoreManagerProtocol!
    
    var currentUser: User?
    var posts: [Post] = []
//    var comments: [Comment] = []
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
            let currentUser = response.users.first!
            storeManager.save(user: currentUser)
            presenter.didLoadNew(post: post)
        }
    }
    
    func deletePost(by index: Int) {
        networkManager.removePost(postId: posts[index].id) { (result) in
            switch result {
            case .failure(let serviceError):
                self.presenter.show(message: serviceError.rawValue)
            case .success(let response):
                guard let deletePost = response.posts.first else { return }
                if let deleteIndex = self.posts.firstIndex(where: { $0.id == deletePost.id })  {
                    self.posts.remove(at: deleteIndex)
                    self.presenter.didRemovePost(by: deleteIndex)
                }
                let currentUser = response.users.first!
                //FIXME: - update user for postCount
                self.storeManager.save(user: currentUser)
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
            case .failure(let serviceError):
                self.presenter.show(message: serviceError.rawValue)
            case .success(let response):
                self.posts.append(contentsOf: response.posts)
                self.users = self.users.union(response.users)
                self.storeManager.append(posts: response.posts)
                self.storeManager.save(users: Array(self.users))
                if response.posts.count == 0 {
                    self.isEndingPosts = true
                } else {
                    self.presenter.didLoadNext(posts: response.posts)
                }
            }
        }
    }
    
    func loadFromStore() {
        storeManager.load { posts, users in
            self.users = Set(users)
            self.posts = posts
        }
    }
    
    func loadPosts() {
        guard !isLoadingPosts else { return }
        isLoadingPosts = true
        isEndingPosts = false
        networkManager.getPosts(fromPostId: nil) { (result) in
            self.isLoadingPosts = false
            switch result {
            case .failure(let serviceError):
                self.presenter.show(message: serviceError.rawValue)
            case .success(let response):
                self.posts = response.posts
                self.users = Set(response.users)
                self.presenter.didLoadFirst(posts: response.posts)
                self.storeManager.save(posts: response.posts)
                self.storeManager.save(users: response.users)
            }
        }
    }
    
    func changeLike(by index: Int) {
        guard let currentUser = currentUser else { return }
        let postId = posts[index].id
        networkManager.changeLike(postId: postId, userId: currentUser.id) { (result) in
            switch result {
            case .failure(let serviceError):
                self.presenter.show(message: serviceError.rawValue)
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
