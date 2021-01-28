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

class LoginInteractor {
    
    unowned let presenter: LoginInteractorOutput
    var networkManager: NetworkManager!
    var storeManager: StoreManager!
    
    init(presenter: LoginInteractorOutput) {
        print("LoginInteractor init")
        self.presenter = presenter
    }
    
    deinit { print("LoginInteractor deinit") }
    
}

extension LoginInteractor: LoginInteractorInput {
    
    func logIn(login: String, password: String) {
        networkManager.logIn(login: login, password: password) { users in
            if let user = users.first {
                let currentUser = CurrentUser(id: user.id, name: user.name, avatarName: user.avatarName)
                self.storeManager.save(currentUser)
                self.presenter.userDidLogined()
            } else {
                self.presenter.userLoginFail()
            }
        }
    }
}
