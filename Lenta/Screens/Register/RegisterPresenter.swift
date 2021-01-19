//
//  RegisterPresenter.swift
//  Lenta
//
//  Created by Alex on 19.01.2021.
//

import Foundation

protocol RegisterViewOutput: class {
    func registerInButtonPress(name: String, login: String, password: String)
    func signInButtonPress()
}

protocol RegisterInteractorOutput {
    
}

class RegisterPresenter {
    
    unowned let view: RegisterViewInput
    var interactor: RegisterInteractorOutput!
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
    
    func registerInButtonPress(name: String, login: String, password: String) {
        
    }
    
    
}

extension RegisterPresenter: RegisterInteractorOutput {
    
    func userDidRegister(currentUser: CurrentUser) {
        router.successDissmis(currentUser: currentUser)
    }
    
    func userNotDidlogin() {
        view.userNotRegister()
    }
}
