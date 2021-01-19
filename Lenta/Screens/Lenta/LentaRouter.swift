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
    var view: UIViewController!
    
    init(assembly: Assembly) {
        print("LentaRouter init")
        self.assembly = assembly
    }
    
    deinit { print("LentaRouter deinit") }
}

extension LentaRouter: LentaRouterInput {
    
    func loginUser(complete: @escaping (CurrentUser) -> Void) {
        let loginVC = assembly.getLoginModule(complete: complete)
//        view.modalPresentationStyle = .fullScreen
        view.present(loginVC, animated: true)
    }
    
    func showEnterNewPostModule(for user: CurrentUser) {
        let newPostVC = assembly.getNewPostModule(for: user)
        view.navigationController?.pushViewController(newPostVC, animated: true)
    }
}
