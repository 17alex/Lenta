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

final class LoginRouter {
    
    private let assembly: Assembly
    unowned private let view: UIViewController
    
    //MARK: - Init
    
    init(assembly: Assembly, view: UIViewController) {
        self.assembly = assembly
        self.view = view
        print("LoginRouter init")
    }
    
    deinit {
        print("LoginRouter deinit")
    }
    
}

//MARK: - LoginRouterInput

extension LoginRouter: LoginRouterInput {
    
    func dissmis() {
        view.dismiss(animated: true, completion: nil)
    }
    
    func showRegisterModule() {
        let registerVC = assembly.getRegisterModule()
        registerVC.modalPresentationStyle = .fullScreen
        let presentingViewController = view.presentingViewController
        view.dismiss(animated: true) {
            if let pVC = presentingViewController {
                pVC.present(registerVC, animated: true)
            }
        }
    }
}
