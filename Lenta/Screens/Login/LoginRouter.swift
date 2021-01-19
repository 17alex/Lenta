//
//  LoginRouter.swift
//  Lenta
//
//  Created by Alex on 18.01.2021.
//

import UIKit

protocol LoginRouterInput {
    func successDissmis(currentUser: CurrentUser)
}

class LoginRouter {
    
    var view: UIViewController!
    let complete: (CurrentUser) -> Void
    
    init(view: UIViewController, complete: @escaping (CurrentUser) -> Void) {
        self.view = view
        self.complete = complete
    }
}

extension LoginRouter: LoginRouterInput {
    
    func successDissmis(currentUser: CurrentUser) {
        complete(currentUser)
        view.dismiss(animated: true, completion: nil)
    }
}
