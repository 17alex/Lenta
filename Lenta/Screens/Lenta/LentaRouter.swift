//
//  LentaRouter.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol LentaRouterInput {
    func showNewPostModule(callback: @escaping (Response) -> Void)
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

//MARK: - LentaRouterInput

extension LentaRouter: LentaRouterInput {
    
    func showNewPostModule(callback: @escaping (Response) -> Void) {
        let newPostVC = assembly.getNewPostModule(callback: callback)
//        view.navigationController?.pushViewController(newPostVC, animated: true)
        view.present(newPostVC, animated: true)
    }
}
