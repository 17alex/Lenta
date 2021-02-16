//
//  NewPostRouter.swift
//  Lenta
//
//  Created by Alex on 14.01.2021.
//

import UIKit

protocol NewPostRouterInput {
    func dismiss()
}

class NewPostRouter {
    
    let assembly: Assembly
    unowned let  view: UIViewController
    
    init(view: UIViewController, assembly: Assembly) {
        print("NewPostRouter init")
        self.view = view
        self.assembly = assembly
    }
    
    deinit { print("NewPostRouter deinit") }
}

//MARK: - NewPostRouterInput

extension NewPostRouter: NewPostRouterInput {
    
    func dismiss() {
        view.navigationController?.popViewController(animated: true)
    }
}
