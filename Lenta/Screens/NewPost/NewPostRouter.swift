//
//  NewPostRouter.swift
//  Lenta
//
//  Created by Alex on 14.01.2021.
//

import UIKit

protocol NewPostRouterInput {
    
}

class NewPostRouter {
    
    let assembly: Assembly
    var view: UIViewController!
    
    init(assembly: Assembly) {
        print("NewPostRouter init")
        self.assembly = assembly
    }
    
    deinit { print("NewPostRouter deinit") }
}

extension NewPostRouter: NewPostRouterInput {
    
}
