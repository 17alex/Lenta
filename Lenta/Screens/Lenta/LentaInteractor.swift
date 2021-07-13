//
//  LentaInteractor.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

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
    func getImage(from urlString: String?, complete: @escaping (UIImage?) -> Void)
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

    // MARK: - Init

    init() {
        print("LentaInteractor init")
    }

    deinit {
        print("LentaInteractor deinit")
    }
}

// MARK: - LentaInteractorInput

extension LentaInteractor: LentaInteractorInput {

    func getImage(from urlString: String?, complete: @escaping (UIImage?) -> Void) {
        networkManager?.loadImage(from: urlString, complete: complete)
    }

    func addNewPost(response: Response) {
        guard let post = response.posts.first else { return }
        posts.insert(post, at: 0)
        users = self.users.union(response.users)
        presenter?.didLoadNew(post: post)
    }

    func deletePost(by index: Int) {
        networkManager?.removePost(postId: posts[index].id) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let serviceError):
                self.presenter?.show(message: serviceError.rawValue)
            case .success(let response):
                guard let deletePost = response.posts.first else { return }
                if let deleteIndex = self.posts.firstIndex(where: { $0.id == deletePost.id }) {
                    self.posts.remove(at: deleteIndex)
                    self.presenter?.didRemovePost(by: deleteIndex)
                }
            }
        }
    }

    func loadNextPosts() {
        guard !isLoadingPosts && !isEndingPosts else { return }
        isLoadingPosts = true
        let lastPostId = posts[posts.count - 1].id
        networkManager?.getPosts(fromPostId: lastPostId) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoadingPosts = false
            switch result {
            case .failure(let serviceError):
                self.presenter?.show(message: serviceError.rawValue)
            case .success(let response):
                self.posts.append(contentsOf: response.posts)
                self.users = self.users.union(response.users)
                self.storeManager?.append(posts: response.posts)
                self.storeManager?.save(users: Array(self.users))
                if response.posts.count == 0 {
                    self.isEndingPosts = true
                } else {
                    self.presenter?.didLoadNext(posts: response.posts)
                }
            }
        }
    }

    func loadFromStore() {
        storeManager?.load { [weak self] posts, users in
            guard let self = self else { return }
            self.users = Set(users)
            self.posts = posts
        }
    }

    func loadPosts() {
        guard !isLoadingPosts else { return }
        isLoadingPosts = true
        isEndingPosts = false
        networkManager?.getPosts(fromPostId: nil) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoadingPosts = false
            switch result {
            case .failure(let serviceError):
                self.presenter?.show(message: serviceError.rawValue)
            case .success(let response):
                self.posts = response.posts
                self.users = Set(response.users)
                self.presenter?.didLoadFirst(posts: response.posts)
                self.storeManager?.save(posts: response.posts)
                self.storeManager?.save(users: response.users)
            }
        }
    }

    func changeLike(by index: Int) {
        guard let currentUser = currentUser else { return }
        let postId = posts[index].id
        networkManager?.changeLike(postId: postId, userId: currentUser.id) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let serviceError):
                self.presenter?.show(message: serviceError.rawValue)
            case .success(let post):
                self.posts[index] = post
                self.presenter?.didUpdatePost(by: index)
            }
        }
    }

    func getCurrenUser() {
        currentUser = storeManager?.getCurrenUser()
    }
}
