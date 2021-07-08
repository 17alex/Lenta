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
    
    weak var presenter: LentaInteractorOutput?
    var networkManager: NetworkManagerProtocol?
    var storeManager: StoreManagerProtocol?
    
    var currentUser: User?
    var posts: [Post] = []
    var users: Set<User> = []
    var isLoadingPosts = false
    var isEndingPosts = false
    
    //MARK: - Init
    
    init() {
        print("LentaInteractor init")
    }
    
    deinit {
        print("LentaInteractor deinit")
    }
}

//MARK: - LentaInteractorInput

extension LentaInteractor: LentaInteractorInput {
    
    func addNewPost(response: Response) {
        guard let post = response.posts.first else { return }
        posts.insert(post, at: 0)
        users = self.users.union(response.users)
        presenter?.didLoadNew(post: post)
    }
    
    func deletePost(by index: Int) {
        networkManager?.removePost(postId: posts[index].id) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let serviceError):
                strongSelf.presenter?.show(message: serviceError.rawValue)
            case .success(let response):
                guard let deletePost = response.posts.first else { return }
                if let deleteIndex = strongSelf.posts.firstIndex(where: { $0.id == deletePost.id })  {
                    strongSelf.posts.remove(at: deleteIndex)
                    strongSelf.presenter?.didRemovePost(by: deleteIndex)
                }
            }
        }
    }
    
    func loadNextPosts() {
        guard !isLoadingPosts && !isEndingPosts else { return }
        isLoadingPosts = true
        let lastPostId = posts[posts.count - 1].id
        networkManager?.getPosts(fromPostId: lastPostId) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingPosts = false
            switch result {
            case .failure(let serviceError):
                strongSelf.presenter?.show(message: serviceError.rawValue)
            case .success(let response):
                strongSelf.posts.append(contentsOf: response.posts)
                strongSelf.users = strongSelf.users.union(response.users)
                strongSelf.storeManager?.append(posts: response.posts)
                strongSelf.storeManager?.save(users: Array(strongSelf.users))
                if response.posts.count == 0 {
                    strongSelf.isEndingPosts = true
                } else {
                    strongSelf.presenter?.didLoadNext(posts: response.posts)
                }
            }
        }
    }
    
    func loadFromStore() {
        storeManager?.load { [weak self] posts, users in
            guard let strongSelf = self else { return }
            strongSelf.users = Set(users)
            strongSelf.posts = posts
        }
    }
    
    func loadPosts() {
        guard !isLoadingPosts else { return }
        isLoadingPosts = true
        isEndingPosts = false
        networkManager?.getPosts(fromPostId: nil) { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.isLoadingPosts = false
            switch result {
            case .failure(let serviceError):
                strongSelf.presenter?.show(message: serviceError.rawValue)
            case .success(let response):
                strongSelf.posts = response.posts
                strongSelf.users = Set(response.users)
                strongSelf.presenter?.didLoadFirst(posts: response.posts)
                strongSelf.storeManager?.save(posts: response.posts)
                strongSelf.storeManager?.save(users: response.users)
            }
        }
    }
    
    func changeLike(by index: Int) {
        guard let currentUser = currentUser else { return }
        let postId = posts[index].id
        networkManager?.changeLike(postId: postId, userId: currentUser.id) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let serviceError):
                strongSelf.presenter?.show(message: serviceError.rawValue)
            case .success(let post):
                strongSelf.posts[index] = post
                strongSelf.presenter?.didUpdatePost(by: index)
            }
        }
    }
    
    func getCurrenUser() {
        currentUser = storeManager?.getCurrenUser()
    }
}
