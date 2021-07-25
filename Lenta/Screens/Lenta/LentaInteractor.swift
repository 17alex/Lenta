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
    var users: [Int16: User] { get }
    func loadFromStorage()
    func loadPosts()
    func loadNextPosts()
    func addNewPost(response: Response)
    func deletePost(by index: Int)
    func changeLike(by index: Int)
    func getCurrenUser()
    func getImage(from urlString: String?, completion: @escaping (Data?) -> Void)
}

final class LentaInteractor {

    weak var presenter: LentaInteractorOutput?
    var networkManager: NetworkManagerProtocol?
    var storageManager: StorageManagerProtocol?

    var currentUser: User?
    var posts: [Post] = []
    var users: [Int16: User] = [:]
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

    func getImage(from urlString: String?, completion: @escaping (Data?) -> Void) {
        networkManager?.loadImage(from: urlString, completion: completion)
    }

    func addNewPost(response: Response) {
        guard let post = response.posts.first else { return }
        posts.insert(post, at: 0)
        response.users.forEach { responseUser in
            users.updateValue(responseUser, forKey: responseUser.id)
        }

        let firstUser = response.users.first
        storageManager?.saveCurrentUserToUserDefaults(user: firstUser)
        storageManager?.update(user: firstUser)
        storageManager?.append(posts: response.posts)
        presenter?.didLoadNew(post: post)
    }

    func deletePost(by index: Int) {
        networkManager?.removePost(postId: posts[index].id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let serviceError):
                self.presenter?.show(error: serviceError)
            case .success(let response):
                guard let deletePost = response.posts.first,
                      let deletePostIndex = self.posts.firstIndex(where: { $0.id == deletePost.id }) else { return }
                self.posts.remove(at: deletePostIndex)
                self.presenter?.didRemovePost(by: deletePostIndex)
                self.storageManager?.save(posts: self.posts)
                let firstUser = response.users.first
                self.storageManager?.saveCurrentUserToUserDefaults(user: firstUser)
                self.storageManager?.update(user: firstUser)
            }
        }
    }

    func loadNextPosts() {
        if isLoadingPosts || isEndingPosts { return }
        isLoadingPosts = true
        let lastPostId = posts[posts.count - 1].id
        networkManager?.getPosts(fromPostId: lastPostId) { [weak self] result in
            guard let self = self else { return }
            self.isLoadingPosts = false
            switch result {
            case .failure(let serviceError):
                self.presenter?.show(error: serviceError)
            case .success(let response):
                self.posts.append(contentsOf: response.posts)
                response.users.forEach { responseUser in
                    self.users.updateValue(responseUser, forKey: responseUser.id)
                }

//                self.users = self.users.union(response.users)

                self.storageManager?.append(posts: response.posts)
                self.storageManager?.save(users: Array(self.users.values))
                if response.posts.isEmpty {
                    self.isEndingPosts = true
                } else {
                    self.presenter?.didLoadNext(posts: response.posts)
                }
            }
        }
    }

    func loadFromStorage() {
        storageManager?.load { [weak self] posts, users in
            guard let self = self else { return }
//            self.users = Set(users)
            self.users = [:]
            users.forEach { user in
                self.users.updateValue(user, forKey: user.id)
            }
            print("self.users =", self.users)
            self.posts = posts
        }
    }

    func loadPosts() {
        if isLoadingPosts { return }
        isLoadingPosts = true
        isEndingPosts = false
        networkManager?.getPosts(fromPostId: nil) { [weak self] result in
            guard let self = self else { return }
            self.isLoadingPosts = false
            switch result {
            case .failure(let serviceError):
                self.presenter?.show(error: serviceError)
            case .success(let response):
                self.posts = response.posts
//                self.users = Set(response.users)
                self.users = [:]
                response.users.forEach { user in
                    self.users.updateValue(user, forKey: user.id)
                }
                self.presenter?.didLoadFirst(posts: response.posts)
                self.storageManager?.save(posts: response.posts)
                self.storageManager?.save(users: response.users)
            }
        }
    }

    func changeLike(by index: Int) {
        guard let currentUser = currentUser else { return }
        let postId = posts[index].id
        networkManager?.changeLike(postId: postId, userId: currentUser.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let serviceError):
                self.presenter?.show(error: serviceError)
            case .success(let post):
                self.posts[index] = post
                self.presenter?.didUpdatePost(by: index)
            }
        }
    }

    func getCurrenUser() {
        currentUser = storageManager?.getCurrenUserFromUserDefaults()
    }
}
