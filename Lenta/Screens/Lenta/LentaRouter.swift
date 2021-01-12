//
//  LentaRouter.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import Foundation

protocol LentaRouterInput {
    
}

class LentaRouter {
    
    let assembly: Assembly
    
    init(assembly: Assembly) {
        print("LentaRouter init")
        self.assembly = assembly
    }
    
    deinit { print("LentaRouter deinit") }
}

extension LentaRouter: LentaRouterInput {
    
}
