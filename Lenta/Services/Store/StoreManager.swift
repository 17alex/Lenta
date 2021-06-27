//
//  StoreManager.swift
//  Lenta
//
//  Created by Alex on 18.01.2021.
//

import Foundation
import  CoreData

protocol StoreManagerProtocol {
    func getCurrenUser() -> User?
    func save(user: User?)
    func load(complete: @escaping ([Post], [User]) -> Void)
    func save(posts: [Post])
    func save(users: [User])
    func append(posts: [Post])
//    func append(users: [User])
}

class StoreManager {
    
    private let userStoreKey = "userStoreKey"
    
    // MARK: - Core Data stack
    
    private lazy var context = persistentContainer.viewContext

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Lenta")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    private func saveContext () {
        print("saveContext")
//        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("saveContext Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func deleteAllPosts() {
        print("deleteAllPosts")
        let fetchRequest: NSFetchRequest = MOPost.fetchRequest()
        do {
            let moPosts = try context.fetch(fetchRequest)
            moPosts.forEach { context.delete($0) }
            saveContext()
        } catch {
            let nserror = error as NSError
            fatalError("deleteAllPosts Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func deleteAllUsers() {
        print("deleteAllUsers")
        let fetchRequest: NSFetchRequest = MOUser.fetchRequest()
        do {
            let moUsers = try context.fetch(fetchRequest)
            moUsers.forEach { context.delete($0) }
            saveContext()
        } catch {
            let nserror = error as NSError
            fatalError("deleteAllUsers Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func add(users: [User]) {
        print("add users")
        users.forEach { user in
            let moUser = MOUser(context: context)
            moUser.id = user.id
            moUser.name = user.name
            moUser.postsCount = user.postsCount
            moUser.dateRegister = Int32(user.dateRegister)
            moUser.avatar = user.avatar
        }
        
        saveContext()
    }
    
    private func add(posts: [Post]) {
        print("add posts")
        posts.forEach { post in
            
            let moPost = MOPost(context: context)
            moPost.id = post.id
            moPost.userId = post.userId
            moPost.timeInterval = Int32(post.timeInterval)
            moPost.descr = post.description
            
            if let photo = post.photo {
                let moPhoto = MOPhoto(context: context)
                moPhoto.name = photo.name
                moPhoto.height = photo.size.height
                moPhoto.width = photo.size.width
                moPost.photo = moPhoto
            }
            
            let moLikes: [MOLike] = post.likeUserIds.map { userId in
                let moLike = MOLike(context: context)
                moLike.userId = userId
                return moLike
//                moPost.addToLikes(<#T##value: MOLike##MOLike#>)
            }
//            moPost.addToLikes(<#T##values: NSSet##NSSet#>)
            moPost.likes = NSSet(array: moLikes)
            moPost.viewsCount = post.viewsCount
            moPost.commentsCount = post.commentsCount
        }
        
        saveContext()
    }
    
    private func loadPosts() -> [Post] {
        let fetchRequestPosts: NSFetchRequest = MOPost.fetchRequest()
        fetchRequestPosts.sortDescriptors = [NSSortDescriptor(key: #keyPath(MOPost.timeInterval), ascending: false)]
        
        do {
            let moPosts = try context.fetch(fetchRequestPosts)
            let posts: [Post] = moPosts.map { moPost in
                
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
            print("LOAD CoreDATA posts =", posts.count)
            return posts
        } catch {
            let nserror = error as NSError
            fatalError("loadPosts Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func loadUsers() -> [User] {
        let fetchRequestUsers: NSFetchRequest = MOUser.fetchRequest()
        
        do {
            let moUsers = try context.fetch(fetchRequestUsers)
            let users: [User] = moUsers.map { moUser in
                return User(id: moUser.id,
                            name: moUser.name,
                            postsCount: moUser.postsCount,
                            dateRegister: TimeInterval(moUser.dateRegister),
                            avatar: moUser.avatar)
            }
            print("LOAD CoreDATA users =", users.count)
            return users
        } catch {
            let nserror = error as NSError
            fatalError("loadUsers Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

//MARK: - StoreManagerProtocol

extension StoreManager: StoreManagerProtocol {
    
    func getCurrenUser() -> User? {
        if let userData = UserDefaults.standard.data(forKey: userStoreKey),
           let currentUser = try? JSONDecoder().decode(User.self, from: userData) {
            print("user in store = \(currentUser)")
            return currentUser
        } else {
            print("user is NOT in store")
            return nil
        }
    }
    
    func save(user: User?) {
        var data: Data?
        if let user = user, let userData = try? JSONEncoder().encode(user) {
            data = userData
        }
        
        UserDefaults.standard.setValue(data, forKey: userStoreKey)
    }
    
    func load(complete: @escaping ([Post], [User]) -> Void) {
        let posts = loadPosts()
        let users = loadUsers()
        complete(posts, users)
    }
    
    func save(posts: [Post]) {
        deleteAllPosts()
        add(posts: posts)
    }
    
    func append(posts: [Post]) {
        add(posts: posts)
    }
    
    func save(users: [User]) {
        deleteAllUsers()
        add(users: users)
    }
    
//    func append(users: [User]) {
//        add(users: users)
//    }
}
