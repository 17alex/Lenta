//
//  CommentsRouter.swift
//  Lenta
//
//  Created by Alex on 10.03.2021.
//

import UIKit

protocol CommentsRouterInput {
    func dismiss()
}

class CommentsRouter {
    
    let assembly: Assembly
    unowned let view: UIViewController
    
    init(view: UIViewController, assembly: Assembly) {
        print("CommentsRouter init")
        self.view = view
        self.assembly = assembly
    }
    
    deinit {
        print("CommentsRouter deinit")
    }
}

//MARK: - CommentsRouterInput

extension CommentsRouter: CommentsRouterInput {
    
    func dismiss() {
        view.dismiss(animated: true)
    }
}
