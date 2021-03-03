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

//MARK: - LoginInteractorInput

extension LoginInteractor: LoginInteractorInput {
    
    func logIn(login: String, password: String) {
        networkManager.logIn(login: login, password: password) { (result) in
            switch result {
            case .failure(let error):
                self.presenter.userLoginFail(message: error.localizedDescription)
            case .success(let users):
                if let user = users.first {
                    let currentUser = CurrentUser(id: user.id, name: user.name, postsCount: user.postsCount, dateRegister: user.dateRegister, avatar: user.avatar)
                    self.storeManager.save(currentUser)
                    self.presenter.userDidLogined()
                } else {
                    self.presenter.userLoginFail(message: "unkmon error")
                }
            }
        }
    }
}
