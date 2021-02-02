//
//  File.swift
//  Lenta
//
//  Created by Alex on 18.01.2021.
//

import Foundation

protocol LoginViewOutput {
    func logIn(login: String, password: String)
    func registerButtonPress()
}

protocol LoginInteractorOutput: class {
    func userDidLogined()
    func userLoginFail(message: String)
}

class LoginPresenter {
    
    unowned let view: LoginViewInput
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!
    
    init(view: LoginViewInput) {
        print("LoginPresenter init")
        self.view = view
    }
    
    deinit {
        print("LoginPresenter deinit")
    }
    
}

extension LoginPresenter: LoginViewOutput {
    
    func registerButtonPress() {
        router.showRegisterModule()
    }
    
    func logIn(login: String, password: String) {
        interactor.logIn(login: login, password: password)
    }
}

extension LoginPresenter: LoginInteractorOutput {
    
    func userDidLogined() {
        router.dissmis()
    }
    
    func userLoginFail(message: String) {
        view.userNotLoginned(message: message)
    }
}
