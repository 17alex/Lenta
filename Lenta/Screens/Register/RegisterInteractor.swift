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

class RegisterInteractor {
    
    unowned let presenter: RegisterInteractorOutput
    var networkManager: NetworkManagerProtocol!
    var storeManager: StoreManagerProtocol!
    
    init(presenter: RegisterInteractorOutput) {
        print("RegisterInteractor init")
        self.presenter = presenter
    }
    
    deinit { print("RegisterInteractor deinit") }
    
}

extension RegisterInteractor: RegisterInteractorInput {
    
    func register(name: String, login: String, password: String, avatarImage: UIImage?) {
        networkManager.register(name: name, login: login, password: password, avatar: avatarImage) { (users) in
            if let user = users.first {
                let currentUser = CurrentUser(id: user.id, name: user.name, avatarName: user.avatarName)
                self.storeManager.save(currentUser)
                self.presenter.userDidRegistered()
            } else {
                self.presenter.userDidRegisteredFail()
            }
        }
    }
}
