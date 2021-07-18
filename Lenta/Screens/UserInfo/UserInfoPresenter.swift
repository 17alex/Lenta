//
//  UserInfoPresenter.swift
//  Lenta
//
//  Created by Алексей Алексеев on 06.07.2021.
//

import UIKit

protocol UserInfoViewOutput {
    func viewDidLoad()
    func closeButtonPress()
}

final class UserInfoPresenter {

    // MARK: - Properties

    unowned private let view: UserInfoViewInput
    private let router: UserInfoRouterInput
    var interactor: UserInfoInteractorInput?
    private var user: UserViewModel

    // MARK: - Init

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

// MARK: - UserInfoViewOutput

extension UserInfoPresenter: UserInfoViewOutput {

    func viewDidLoad() {
        view.set(user: user)
        interactor?.getImage(from: user.avatarUrlString, complete: { [weak self] avatarData in
            guard let self = self, let avatarData = avatarData else { return }
            let avatarImage = UIImage(data: avatarData) ?? UIImage(named: "defaultAvatar")
            self.view.set(avatar: avatarImage)
        })
    }

    func closeButtonPress() {
        router.dismiss(animated: true)
    }
}
