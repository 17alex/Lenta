//
//  LoginRouter.swift
//  Lenta
//
//  Created by Alex on 18.01.2021.
//

import UIKit

protocol LoginRouterInput {
    func dissmis()
    func showRegisterModule()
}

class LoginRouter {
    
    let assembly: Assembly
    unowned let view: UIViewController
    
    init(assembly: Assembly, view: UIViewController) {
        self.assembly = assembly
        self.view = view
        print("LoginRouter init")
    }
    
    deinit {
        print("LoginRouter deinit")
    }
    
}

extension LoginRouter: LoginRouterInput {
    
    func dissmis() {
        view.dismiss(animated: true, completion: nil)
    }
    
    func showRegisterModule() {
        let registerVC = assembly.getRegisterModule()
        registerVC.modalPresentationStyle = .fullScreen
        view.dismiss(animated: true) {
            if let lastView = self.assembly.navigationController.viewControllers.last {
                lastView.present(registerVC, animated: true)
            }
        }
    }
}
