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

protocol LoginInteractorOutput: AnyObject {
    func userDidLogined()
    func userLoginFail(error: NetworkServiceError)
}

final class LoginPresenter {

    unowned private let view: LoginViewInput
    var interactor: LoginInteractorInput?
    var router: LoginRouterInput?

    // MARk: - Init

    init(view: LoginViewInput) {
        print("LoginPresenter init")
        self.view = view
    }

    deinit {
        print("LoginPresenter deinit")
    }

}

// MARK: - LoginViewOutput

extension LoginPresenter: LoginViewOutput {

    func registerButtonPress() {
        router?.showRegisterModule()
    }

    func logIn(login: String, password: String) {
        interactor?.logIn(login: login, password: password)
    }
}

// MARK: - LoginInteractorOutput

extension LoginPresenter: LoginInteractorOutput {

    func userDidLogined() {
        router?.dissmis()
    }

    func userLoginFail(error: NetworkServiceError) {
        view.userNotLoginned(message: error.rawValue)
    }
}
