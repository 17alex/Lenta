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

final class CommentsRouter {
    
    private let assembly: Assembly
    unowned private let view: UIViewController
    
    //MARK: Init
    
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
