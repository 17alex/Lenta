//
//  LentaRouter.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

protocol LentaRouterInput {
    func showNewPostModule(callback: @escaping (Response) -> Void)
    func showCommentsModule(by postId: Int)
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
    
    func showCommentsModule(by postId: Int) {
        let commensVC = assembly.getCommentsModule(by: postId)
        view.present(commensVC, animated: true)
    }
    
    func showNewPostModule(callback: @escaping (Response) -> Void) {
        let newPostVC = assembly.getNewPostModule(callback: callback)
        view.present(newPostVC, animated: true)
    }
}
