//
//  LentaRouter.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol LentaRouterInput {
    func showEnterNewPostModule()
    func showMenuModule()
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
    
    func showEnterNewPostModule() {
        let newPostVC = assembly.getNewPostModule()
        assembly.navigationController.pushViewController(newPostVC, animated: true)
    }
    
    func showMenuModule() {
        let menuVC = assembly.getMenuModule()
        assembly.navigationController.pushViewController(menuVC, animated: true)
    }
}
