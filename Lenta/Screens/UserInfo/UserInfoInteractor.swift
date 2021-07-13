//
//  UserInfoInteractor.swift
//  Lenta
//
//  Created by Алексей Алексеев on 13.07.2021.
//

import UIKit //FIXME: - No UIImage to Data

protocol UserInfoInteractorInput {
    func getImage(from urlString: String?, complete: @escaping (UIImage?) -> Void)
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

    func getImage(from urlString: String?, complete: @escaping (UIImage?) -> Void) {
        networkManager?.loadImage(from: urlString, complete: complete)
    }
}
