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

final class ProfileRouter {
    
    // Propertis
    
    unowned private let view: UIViewController
    private let assembly: Assembly
    
    //Init
    
    init(view: UIViewController, assembly: Assembly) {
        self.view = view
        self.assembly = assembly
    }
}

//MARK: - ProfileRouterInput

extension ProfileRouter: ProfileRouterInput {
    
    func loginUser() {
        let loginVC = assembly.getLoginModule()
        loginVC.modalPresentationStyle = .fullScreen
        view.present(loginVC, animated: true)
    }
}
