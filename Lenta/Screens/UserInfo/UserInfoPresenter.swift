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
    private var userId: Int16

    // MARK: - Init

    init(view: UserInfoViewInput, router: UserInfoRouterInput, userId: Int16) {
        self.view = view
        self.router = router
        self.userId = userId
        print("UserInfoPresenter init")
    }

    deinit {
        print("UserInfoPresenter deinit")
    }

    // MARK: - Metods

    private func setImage(userViewModel: UserViewModel) {
        self.interactor?.getImage(from: userViewModel.avatarUrlString, completion: { [weak self] avatarData in
            guard let self = self, let avatarData = avatarData else { return }
            let avatarImage = UIImage(data: avatarData) ?? UIImage(named: "defaultAvatar")
            self.view.set(avatar: avatarImage)
        })
    }

}

// MARK: - UserInfoViewOutput

extension UserInfoPresenter: UserInfoViewOutput {

    func viewDidLoad() {

        interactor?.getUser(for: userId, completion: { [weak self] user in
            guard let self = self else { return }
            if let userViewModel = UserViewModel(user: user) {
                self.view.set(user: userViewModel)
                self.setImage(userViewModel: userViewModel)
            }
        })
    }

    func closeButtonPress() {
        router.dismiss(animated: true)
    }
}
