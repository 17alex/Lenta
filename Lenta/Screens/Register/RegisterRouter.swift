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

class RegisterRouter {
    
    let assembly: Assembly
    unowned let view: UIViewController!
    
    init(assembly: Assembly, view: UIViewController) {
        self.assembly = assembly
        self.view = view
        print("RegisterRouter init")
    }
    
    deinit {
        print("RegisterRouter deinit")
    }
}

extension RegisterRouter: RegisterRouterInput {
    
    func dissmis() {
        view.dismiss(animated: true, completion: nil)
    }
    
    func showLoginedModule() {
        let loginVC = assembly.getLoginModule()
        loginVC.modalPresentationStyle = .fullScreen
        view.dismiss(animated: true) {
            if let lastView = self.assembly.navigationController.viewControllers.last {
                lastView.present(loginVC, animated: true)
            }
        }
    }
}
