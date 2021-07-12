//
//  RegisterInteractor.swift
//  Lenta
//
//  Created by Alex on 19.01.2021.
//

import UIKit

protocol RegisterInteractorInput {
    func register(name: String, login: String, password: String, avatarImage: UIImage?)
}

final class RegisterInteractor {

    unowned private let presenter: RegisterInteractorOutput
    var networkManager: NetworkManagerProtocol?
    var storeManager: StoreManagerProtocol?

    init(presenter: RegisterInteractorOutput) {
        print("RegisterInteractor init")
        self.presenter = presenter
    }

    deinit { print("RegisterInteractor deinit") }

}

// MARK: - RegisterInteractorInput

extension RegisterInteractor: RegisterInteractorInput {

    func register(name: String, login: String, password: String, avatarImage: UIImage?) {
        networkManager?.register(name: name, login: login, password: password,
                                 avatar: avatarImage) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let serviceError):
                strongSelf.presenter.userDidRegisteredFail(message: serviceError.rawValue)
            case .success(let users):
                if let currentUser = users.first {
                    strongSelf.storeManager?.save(user: currentUser)
                    strongSelf.presenter.userDidRegistered()
                } else {
                    strongSelf.presenter.userDidRegisteredFail(message: "unkmon error")
                }
            }
        }
    }
}
