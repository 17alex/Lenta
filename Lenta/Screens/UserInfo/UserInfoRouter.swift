//
//  UserInfoRouter.swift
//  Lenta
//
//  Created by Алексей Алексеев on 06.07.2021.
//

import UIKit

protocol UserInfoRouterInput {
    func dismiss(animated: Bool)
}

final class UserInfoRouter {

    // MARK: - Properties

    unowned private let view: UIViewController
    private let assembly: Assembly

    // MARK: - Init

    init(view: UIViewController, assembly: Assembly) {
        self.view = view
        self.assembly = assembly
        print("UserInfoRouter init")
    }

    deinit {
        print("UserInfoRouter deinit")
    }
}

// MARK: - UserInfoRouterInput

extension UserInfoRouter: UserInfoRouterInput {

    func dismiss(animated: Bool) {
        view.dismiss(animated: animated)
    }
}
