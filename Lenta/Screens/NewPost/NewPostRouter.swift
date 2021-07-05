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

final class NewPostRouter {
    
    let assembly: Assembly
    unowned let  view: UIViewController
    
    //MARK: - Init
    
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
        view.dismiss(animated: true)
    }
}
