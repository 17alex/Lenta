//
//  RegisterRouter.swift
//  Lenta
//
//  Created by Alex on 19.01.2021.
//

import UIKit

protocol RegisterRouterInput {
    func dissmis()
    func showLoginedModule()
}

final class RegisterRouter {

    private let assembly: Assembly
    unowned private let view: UIViewController

    // MARK: - Init

    init(assembly: Assembly, view: UIViewController) {
        self.assembly = assembly
        self.view = view
        print("RegisterRouter init")
    }

    deinit {
        print("RegisterRouter deinit")
    }
}

// MARK: - RegisterRouterInput

extension RegisterRouter: RegisterRouterInput {

    func dissmis() {
        view.dismiss(animated: true, completion: nil)
    }

    func showLoginedModule() {
        let loginVC = assembly.getLoginModule()
        loginVC.modalPresentationStyle = .fullScreen
        let presentingViewController = view.presentingViewController
        view.dismiss(animated: true) {
            if let pVC = presentingViewController {
                pVC.present(loginVC, animated: true)
            }
        }
    }
}
