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

//MARK: - RegisterRouterInput

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
