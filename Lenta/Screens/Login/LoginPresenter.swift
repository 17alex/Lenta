//
//  File.swift
//  Lenta
//
//  Created by Alex on 18.01.2021.
//

import Foundation

protocol LoginPresenterInput {
    func logIn(login: String, password: String)
}

protocol LoginInteractorOutput {
    func userDidLogin(currentUser: CurrentUser)
    func userNotDidlogin()
}

class LoginPresenter {
    
    unowned let view: LoginViewInput
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!
    
    init(view: LoginViewInput) {
        print("LoginPresenter init")
        self.view = view
    }
    
    deinit { print("LoginPresenter init") }
    
}

extension LoginPresenter: LoginPresenterInput {
    
    func logIn(login: String, password: String) {
        interactor.logIn(login: login, password: password)
    }
}

extension LoginPresenter: LoginInteractorOutput {
    
    func userDidLogin(currentUser: CurrentUser) {
        router.successDissmis(currentUser: currentUser)
    }
    
    func userNotDidlogin() {
        view.userNotLoginned()
    }
    
    
}
