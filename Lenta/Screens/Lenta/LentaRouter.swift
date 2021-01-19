//
//  LentaRouter.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol LentaRouterInput {
    func showEnterNewPostModule(for user: CurrentUser)
    func loginUser(complete: @escaping (CurrentUser) -> Void)
}

class LentaRouter {
    
    let assembly: Assembly
    unowned let view: UIViewController
    
    init(view: UIViewController, assembly: Assembly) {
        print("LentaRouter init")
        self.view = view
        self.assembly = assembly
    }
    
    deinit {
        print("LentaRouter deinit")
    }
}

extension LentaRouter: LentaRouterInput {
    
    func loginUser(complete: @escaping (CurrentUser) -> Void) {
        let loginVC = assembly.getLoginModule(complete: complete)
        view.present(loginVC, animated: true)
    }
    
    func showEnterNewPostModule(for user: CurrentUser) {
        let newPostVC = assembly.getNewPostModule(for: user)
        assembly.navigationController.pushViewController(newPostVC, animated: true)
    }
}
