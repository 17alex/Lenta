//
//  LoginInteractor.swift
//  Lenta
//
//  Created by Alex on 18.01.2021.
//

import Foundation

protocol LoginInteractorInput {
    func logIn(login: String, password: String)
}

final class LoginInteractor {

    unowned private let presenter: LoginInteractorOutput
    var networkManager: NetworkManagerProtocol?
    var storageManager: StorageManagerProtocol?

    // MARK: - Init

    init(presenter: LoginInteractorOutput) {
        print("LoginInteractor init")
        self.presenter = presenter
    }

    deinit { print("LoginInteractor deinit") }

}

// MARK: - LoginInteractorInput

extension LoginInteractor: LoginInteractorInput {

    func logIn(login: String, password: String) {
        networkManager?.login(login: login, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let serviceError):
                self.presenter.userLoginFail(error: serviceError)
            case .success(let users):
                if let currentUser = users.first {
//                    self.storageManager?.save(user: currentUser)
                    self.storageManager?.saveCurrentUserId(userId: currentUser.id)
                    self.presenter.userDidLogined()
                } else {
                    self.presenter.userLoginFail(error: .unknown)
                }
            }
        }
    }
}
