//
//  UserInfoInteractor.swift
//  Lenta
//
//  Created by Алексей Алексеев on 13.07.2021.
//

import Foundation

protocol UserInfoInteractorInput {
    func getUser(for id: Int16, completion: @escaping (User?) -> Void)
    func getImage(from urlString: String?, completion: @escaping (Data?) -> Void)
}

final class UserInfoInteractor {

    // MARK: - Properties

    var networkManager: NetworkManagerProtocol?
    var storageManager: StorageManagerProtocol?

    // MARK: - Init

    init() {
        print("UserInfoInteractor init")
    }

    deinit {
        print("UserInfoInteractor deinit")
    }
}

// MARK: - UserInfoInteractorInput

extension UserInfoInteractor: UserInfoInteractorInput {

    func getUser(for id: Int16, completion: @escaping (User?) -> Void) {
        guard let users = storageManager?.loadUsers() else { completion(nil); return }
        let fileterUser = users.filter { user in
            user.id == id
        }
        print("user =", fileterUser)
        completion(fileterUser.first)
    }

    func getImage(from urlString: String?, completion: @escaping (Data?) -> Void) {
        networkManager?.loadImage(from: urlString, completion: completion)
    }
}
