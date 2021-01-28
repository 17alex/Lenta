//
//  ProfileRouter.swift
//  Lenta
//
//  Created by Alex on 27.01.2021.
//

import UIKit

protocol ProfileRouterInput {
    func loginUser()
}

class ProfileRouter {
    
    unowned let view: UIViewController
    let assembly: Assembly
    
    init(view: UIViewController, assembly: Assembly) {
        self.view = view
        self.assembly = assembly
    }
}

extension ProfileRouter: ProfileRouterInput {
    
    func loginUser() {
        let loginVC = assembly.getLoginModule()
        loginVC.modalPresentationStyle = .fullScreen
        view.present(loginVC, animated: true)
    }
}
