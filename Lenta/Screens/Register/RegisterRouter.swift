//
//  RegisterRouter.swift
//  Lenta
//
//  Created by Alex on 19.01.2021.
//

import UIKit

protocol RegisterRouterInput {
    func successDissmis(currentUser: CurrentUser)
    func showLoginedModule()
}

class RegisterRouter {
    
    let assembly: Assembly
    unowned let view: UIViewController!
    let complete: (CurrentUser) -> Void
    
    init(assembly: Assembly, view: UIViewController, complete: @escaping (CurrentUser) -> Void) {
        self.assembly = assembly
        self.view = view
        self.complete = complete
        print("RegisterRouter init")
    }
    
    deinit {
        print("RegisterRouter deinit")
    }
}

extension RegisterRouter: RegisterRouterInput {
    
    func successDissmis(currentUser: CurrentUser) {
        complete(currentUser)
        view.dismiss(animated: true, completion: nil)
    }
    
    func showLoginedModule() {
        let loginVC = assembly.getLoginModule(complete: complete)
        view.dismiss(animated: true) {
            if let lastView = self.assembly.navigationController.viewControllers.last {
                lastView.present(loginVC, animated: true, completion: nil)
            }
        }
    }
}
