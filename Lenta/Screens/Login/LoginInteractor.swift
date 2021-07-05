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
    var storeManager: StoreManagerProtocol?
    
    //MARK: - Init
    
    init(presenter: LoginInteractorOutput) {
        print("LoginInteractor init")
        self.presenter = presenter
    }
    
    deinit { print("LoginInteractor deinit") }
    
}

//MARK: - LoginInteractorInput

extension LoginInteractor: LoginInteractorInput {
    
    func logIn(login: String, password: String) {
        networkManager?.logIn(login: login, password: password) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let serviceError):
                strongSelf.presenter.userLoginFail(message: serviceError.rawValue)
            case .success(let users):
                if let currentUser = users.first {
                    strongSelf.storeManager?.save(user: currentUser)
                    strongSelf.presenter.userDidLogined()
                } else {
                    strongSelf.presenter.userLoginFail(message: "unkmon error")
                }
            }
        }
    }
}
