//
//  RegisterPresenter.swift
//  Lenta
//
//  Created by Alex on 19.01.2021.
//

import UIKit

protocol RegisterViewOutput: AnyObject {
    func registerButtonPress(name: String, login: String, password: String, avatarImage: UIImage?)
    func signInButtonPress()
}

protocol RegisterInteractorOutput: AnyObject {
    func userDidRegistered()
    func userDidRegisteredFail(message: String)
}

final class RegisterPresenter {

    unowned private let view: RegisterViewInput
    var interactor: RegisterInteractorInput?
    var router: RegisterRouterInput?

    // MARK: - Init

    init(view: RegisterViewInput) {
        print("RegisterPresenter init")
        self.view = view
    }

    deinit {
        print("RegisterPresenter deinit")
    }
}

// MARK: - RegisterViewOutput

extension RegisterPresenter: RegisterViewOutput {

    func signInButtonPress() {
        router?.showLoginedModule()
    }

    func registerButtonPress(name: String, login: String, password: String, avatarImage: UIImage?) {
        interactor?.register(name: name, login: login, password: password, avatarImage: avatarImage)
    }
}

// MARK: - RegisterInteractorOutput

extension RegisterPresenter: RegisterInteractorOutput {

    func userDidRegistered() {
        router?.dissmis()
    }

    func userDidRegisteredFail(message: String) {
        view.userNotRegister(message: message)
    }
}
