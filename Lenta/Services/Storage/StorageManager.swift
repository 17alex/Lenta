//
//  storageManager.swift
//  Lenta
//
//  Created by Alex on 18.01.2021.
//

import Foundation
import  CoreData

protocol StorageManagerProtocol {
    func getCurrenUserFromUserDefaults() -> User?
    func saveCurrentUserToUserDefaults(user: User?)
    func load(completion: @escaping ([Post], [User]) -> Void)
    func save(posts: [Post])
    func save(users: [User])
    func loadUsers() -> [User]
    func append(posts: [Post])
    func append(user: User)
    func getUser(for userId: Int16?) -> User?
    func update(user: User?)
}

final class StorageManager {

    // MARK: - Properties

    private let userStorageKey = "userStorageKey"
    private lazy var context = persistentContainer.viewContext
    private lazy var bgContext = persistentContainer.newBackgroundContext()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Lenta")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Init

    init() {
        print("storageManager init")
    }

    deinit {
        print("storageManager deinit")
    }

    // MARK: - Core Data Metods

    private func deleteAllPosts() {
        print("deleteAllPosts")
        bgContext.performAndWait {
            let fetchRequest: NSFetchRequest = MOPost.fetchRequest()
            if let moPosts = try? bgContext.fetch(fetchRequest) {
                moPosts.forEach { bgContext.delete($0) }
            }
            try? bgContext.save()
        }
    }

    private func deleteAllUsers() {
        print("deleteAllUsers")
        bgContext.performAndWait {
            let fetchRequest: NSFetchRequest = MOUser.fetchRequest()
            if let moUsers = try? bgContext.fetch(fetchRequest) {
                moUsers.forEach { bgContext.delete($0) }
            }

            try? bgContext.save()
        }
    }

    private func add(users: [User]) {
        print("add users count =", users.count)
        bgContext.performAndWait {
            users.forEach { user in
                let moUser = MOUser(context: bgContext)
                moUser.id = user.id
                moUser.name = user.name
                moUser.postsCount = user.postsCount
                moUser.dateRegister = Int32(user.dateRegister)
                moUser.avatar = user.avatar
            }
        }

        try? bgContext.save()
    }

    private func add(posts: [Post]) {
        print("add posts count =", posts.count)
        bgContext.performAndWait {
            posts.forEach { post in

                let moPost = MOPost(context: bgContext)
                moPost.id = post.id
                moPost.userId = post.userId
                moPost.timeInterval = Int32(post.timeInterval)
                moPost.descr = post.description

                if let photo = post.photo {
                    let moPhoto = MOPhoto(context: bgContext)
                    moPhoto.name = photo.name
                    moPhoto.height = photo.size.height
                    moPhoto.width = photo.size.width
                    moPost.photo = moPhoto
                }

                post.likeUserIds.forEach { userId in
                    let moLike = MOLike(context: bgContext)
                    moLike.userId = userId
                    moPost.addToLikes(moLike)
                }

                moPost.viewsCount = post.viewsCount
                moPost.commentsCount = post.commentsCount
            }
        }

        try? bgContext.save()
    }

    private func loadAllPosts() -> [Post] {
        let fetchRequestPosts: NSFetchRequest = MOPost.fetchRequest()
        fetchRequestPosts.sortDescriptors = [NSSortDescriptor(key: #keyPath(MOPost.timeInterval), ascending: false)]
        var posts: [Post] = []
        context.performAndWait {
            guard let moPosts = try? context.fetch(fetchRequestPosts) else { return }
            posts = moPosts.map { moPost in

                var photo: PostPhoto?
                if let moPhoto = moPost.photo {
                    photo = PostPhoto(name: moPhoto.name, size: Size(width: moPhoto.width, height: moPhoto.height))
                }

                var likes: [Int16] = []
                if let moLikes = moPost.likes.allObjects as? [MOLike] {
                    likes = moLikes.map { moLike in
                        moLike.userId
                    }
                }

                return Post(id: moPost.id,
                            userId: moPost.userId,
                            timeInterval: TimeInterval(moPost.timeInterval),
                            description: moPost.descr,
                            photo: photo,
                            likeUserIds: likes,
                            viewsCount: moPost.viewsCount,
                            commentsCount: moPost.commentsCount)
            }
        }
        print("LOAD from CoreDATA, posts =", posts.count)
        return posts
    }

    private func loadAllUsers() -> [User] {
        let fetchRequestUsers: NSFetchRequest = MOUser.fetchRequest()
        var users: [User] = []
        context.performAndWait {
            guard let moUsers = try? context.fetch(fetchRequestUsers) else { return }
            users = moUsers.map { moUser in
                return User(id: moUser.id,
                            name: moUser.name,
                            postsCount: moUser.postsCount,
                            dateRegister: TimeInterval(moUser.dateRegister),
                            avatar: moUser.avatar)
            }
        }
        print("LOAD from CoreDATA, users.count =", users.count)
        print("LOAD from CoreDATA, users =", users)
        return users
    }
}

// MARK: - StorageManagerProtocol

extension StorageManager: StorageManagerProtocol {

    func getCurrenUserFromUserDefaults() -> User? {
        if let userData = UserDefaults.standard.data(forKey: userStorageKey),
           let currentUser = try? JSONDecoder().decode(User.self, from: userData) {
            print("user in UserDefaults = \(currentUser)")
            return currentUser
        } else {
            print("user is NOT in UserDefaults")
            return nil
        }
    }

    func saveCurrentUserToUserDefaults(user: User?) {
        if let user = user, let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.setValue(userData, forKey: userStorageKey)
            print("UserDefaults  saveCurrentUser =", user)
        } else {
            UserDefaults.standard.removeObject(forKey: userStorageKey)
            print("UserDefaults  remove currentUser")
        }
    }

    func load(completion: @escaping ([Post], [User]) -> Void) {
        let posts = loadAllPosts()
        let users = loadAllUsers()
        completion(posts, users)
    }

    func save(posts: [Post]) {
        deleteAllPosts()
        add(posts: posts)
    }

    func append(posts: [Post]) {
        add(posts: posts)
    }

    func append(user: User) {
        add(users: [user])
    }

    func save(users: [User]) {
        deleteAllUsers()
        add(users: users)
    }

    func loadUsers() -> [User] {
        return loadAllUsers()
    }

    func getUser(for userId: Int16?) -> User? {
        guard let userId = userId else { return nil }
        let fetchRequestUsers: NSFetchRequest = MOUser.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", userId)
        fetchRequestUsers.predicate = predicate
        var users: [User] = []
        context.performAndWait {
            guard let moUsers = try? context.fetch(fetchRequestUsers) else { return }
            users = moUsers.map { moUser in
                return User(id: moUser.id,
                            name: moUser.name,
                            postsCount: moUser.postsCount,
                            dateRegister: TimeInterval(moUser.dateRegister),
                            avatar: moUser.avatar)
            }
        }

        print("CoreData getUser for id =", userId, ", users =", users)
        return users.first
    }

    func update(user: User?) {
        guard let user = user else { return }
        let fetchRequestUsers: NSFetchRequest = MOUser.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", user.id)
        fetchRequestUsers.predicate = predicate
        context.performAndWait {
            if let moUser = try? context.fetch(fetchRequestUsers).first {
                moUser.id = user.id
                moUser.name = user.name
                moUser.postsCount = Int16(user.postsCount)
                moUser.dateRegister = Int32(user.dateRegister)
                moUser.avatar = user.avatar
                try? context.save()
                print("CoreData update user =", user)
            } else {
                let moUser = MOUser(context: context)
                moUser.id = user.id
                moUser.name = user.name
                moUser.postsCount = user.postsCount
                moUser.dateRegister = Int32(user.dateRegister)
                moUser.avatar = user.avatar
                print("CoreData update/create user =", user)
            }
        }
    }
}
