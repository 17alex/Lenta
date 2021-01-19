//
//  LoginRouter.swift
//  Lenta
//
//  Created by Alex on 18.01.2021.
//

import UIKit

protocol LoginRouterInput {
    func successDissmis(currentUser: CurrentUser)
    func showRegisterModule()
}

class LoginRouter {
    
    let assembly: Assembly
    unowned let view: UIViewController
    let complete: (CurrentUser) -> Void
    
    init(assembly: Assembly, view: UIViewController, complete: @escaping (CurrentUser) -> Void) {
        self.assembly = assembly
        self.view = view
        self.complete = complete
        print("LoginRouter init")
    }
    
    deinit {
        print("LoginRouter deinit")
    }
    
}

extension LoginRouter: LoginRouterInput {
    
    func successDissmis(currentUser: CurrentUser) {
        complete(currentUser)
        view.dismiss(animated: true, completion: nil)
    }
    
    func showRegisterModule() {
        let registerVC = assembly.getRegisterModule(complete: complete)
        view.dismiss(animated: true) {
            if let lastView = self.assembly.navigationController.viewControllers.last {
                lastView.present(registerVC, animated: true, completion: nil)
            }
        }
    }
}
