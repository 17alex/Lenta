//
//  UserInfoPresenter.swift
//  Lenta
//
//  Created by Алексей Алексеев on 06.07.2021.
//

import Foundation

protocol UserInfoViewOutput {
    func viewDidLoad()
    func closeButtonPress()
}

final class UserInfoPresenter {
    
    //MARK: - Propertis
    
    unowned private let view: UserInfoViewInput
    private let router: UserInfoRouterInput
    
    private var user: UserViewModel
    
    //MARK: - Init
    
    init(view: UserInfoViewInput, router: UserInfoRouterInput, user: UserViewModel) {
        self.view = view
        self.router = router
        self.user = user
        print("UserInfoPresenter init")
    }
    
    deinit {
        print("UserInfoPresenter deinit")
    }
    
}

//MARK: - UserInfoViewOutput

extension UserInfoPresenter: UserInfoViewOutput {
    
    func viewDidLoad() {
        view.set(user: user)
    }
    
    func closeButtonPress() {
        router.dismiss(animated: true)
    }
}
