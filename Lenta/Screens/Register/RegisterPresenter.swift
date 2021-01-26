//
//  RegisterPresenter.swift
//  Lenta
//
//  Created by Alex on 19.01.2021.
//

import UIKit

protocol RegisterViewOutput: class {
    func registerButtonPress(name: String, login: String, password: String, avatarImage: UIImage?)
    func signInButtonPress()
}

protocol RegisterInteractorOutput: class {
    func userDidRegister(currentUser: CurrentUser)
    func userNotDidRegister()
}

class RegisterPresenter {
    
    unowned let view: RegisterViewInput
    var interactor: RegisterInteractorInput!
    var router: RegisterRouterInput!
    
    init(view: RegisterViewInput) {
        print("RegisterPresenter init")
        self.view = view
    }
    
    deinit {
        print("RegisterPresenter deinit")
    }
}

extension RegisterPresenter: RegisterViewOutput {
    
    func signInButtonPress() {
        router.showLoginedModule()
    }
    
    func registerButtonPress(name: String, login: String, password: String, avatarImage: UIImage?) {
        interactor.register(name: name, login: login, password: password, avatarImage: avatarImage)
    }
}

extension RegisterPresenter: RegisterInteractorOutput {
    
    func userDidRegister(currentUser: CurrentUser) {
        router.successDissmis(currentUser: currentUser)
    }
    
    func userNotDidRegister() {
        view.userNotRegister()
    }
}
