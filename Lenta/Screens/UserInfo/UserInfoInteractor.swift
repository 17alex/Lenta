//
//  UserInfoInteractor.swift
//  Lenta
//
//  Created by Алексей Алексеев on 13.07.2021.
//

import Foundation

protocol UserInfoInteractorInput {
    func getImage(from urlString: String?, completion: @escaping (Data?) -> Void)
}

final class UserInfoInteractor {

    // MARK: - Properties

    var networkManager: NetworkManagerProtocol?

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

    func getImage(from urlString: String?, completion: @escaping (Data?) -> Void) {
        networkManager?.loadImage(from: urlString, completion: completion)
    }
}
