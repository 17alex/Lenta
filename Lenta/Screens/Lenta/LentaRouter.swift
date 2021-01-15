//
//  LentaRouter.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol LentaRouterInput {
    func addButtonPress()
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
    
    func addButtonPress() {
        let newPostVC = assembly.getNewPostModule()
        view.navigationController?.pushViewController(newPostVC, animated: true)
    }
}
