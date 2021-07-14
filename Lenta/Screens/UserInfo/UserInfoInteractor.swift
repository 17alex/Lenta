//
//  UserInfoInteractor.swift
//  Lenta
//
//  Created by Алексей Алексеев on 13.07.2021.
//

import Foundation

protocol UserInfoInteractorInput {
    func getImage(from urlString: String?, complete: @escaping (Data?) -> Void)
}

final class UserInfoInteractor {

    // MARK: - Propertis

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

    func getImage(from urlString: String?, complete: @escaping (Data?) -> Void) {
        networkManager?.loadImage(from: urlString, complete: complete)
    }
}
