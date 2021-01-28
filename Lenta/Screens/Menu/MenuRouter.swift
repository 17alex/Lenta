//
//  MenuRouter.swift
//  Lenta
//
//  Created by Alex on 27.01.2021.
//

import UIKit

protocol MenuRouterInput {
    func showProfileModule()
}

class MenuRouter {
    
    let assembly: Assembly
    unowned let view: UIViewController
    
    init(view: UIViewController, assembly: Assembly) {
        print("MenuRouter init")
        self.view = view
        self.assembly = assembly
    }
    
    deinit {
        print("MenuRouter deinit")
    }
}

extension MenuRouter: MenuRouterInput {
    
    func showProfileModule() {
        let profileVC = assembly.getProfileModule()
        assembly.navigationController.pushViewController(profileVC, animated: true)
    }
}
