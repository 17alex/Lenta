//
//  ProfilePresenter.swift
//  Lenta
//
//  Created by Alex on 27.01.2021.
//

import UIKit

protocol ProfileViewOutput {
    func start()
    func change(name: String)
    func didSelectNewAvatar()
    func logInOutButtonPress()
    func saveButtonPress(name: String, image: UIImage?)
}

protocol ProfileInteractorOutput: AnyObject {
    func saveProfileFailed(serviceError: NetworkServiceError)
    func saveProfileSuccess()
    func saveProfileError()
    func currentUser(currentUser: User?)
    func changeProfile(_ change: Bool)
    func toLogin()
}

final class ProfilePresenter {

    // MARK: - Properties

    unowned private let view: ProfileViewInput
    private let interactor: ProfileInteractorInput
    var router: ProfileRouterInput?

    // MARK: - Init

    init(view: ProfileViewInput, interactor: ProfileInteractorInput) {
        self.view = view
        self.interactor = interactor
        print("ProfilePresenter init")
    }

    deinit {
        print("ProfilePresenter deinit")
    }
}

// MARK: - ProfileViewOutput

extension ProfilePresenter: ProfileViewOutput {

    func saveButtonPress(name: String, image: UIImage?) {
        view.saveButton(isShow: false)
        view.activityIndicatorStart()
        var imageData: Data?
        if let image = image {
            imageData = image.jpegData(compressionQuality: 0.25)
        }

        interactor.saveProfile(name: name, image: imageData)
    }

    func logInOutButtonPress() {
        interactor.logInOutButtonPress()
    }

    func didSelectNewAvatar() {
        interactor.didSelectNewAvatar()
    }

    func change(name: String) {
        interactor.change(name: name)
    }

    func start() {
        interactor.start()
    }
}

// MARK: - ProfileInteractorOutput

extension ProfilePresenter: ProfileInteractorOutput {

    func saveProfileFailed(serviceError: NetworkServiceError) {
        view.activityIndicatorStop()
        view.saveButton(isShow: true)
        view.showMessage(serviceError.rawValue)
    }

    func saveProfileSuccess() {
        view.activityIndicatorStop()
        view.showMessage("update successfull")
    }

    func saveProfileError() {
        view.activityIndicatorStop()
        view.saveButton(isShow: true)
        view.showMessage("error update")
    }

    func currentUser(currentUser: User?) {
        if let userViewModel = UserViewModel(user: currentUser) {
            view.showUserInfo(userModel: userViewModel)
            interactor.getImage(from: userViewModel.avatarUrlString) { [weak self] avatarData in
                guard let self = self, let avatarData = avatarData else { return }
                let avatarImage = UIImage(data: avatarData) ?? UIImage(named: "avatar")
                self.view.set(avatar: avatarImage)
            }
        } else {
            view.clearUserInfo()
        }
    }

    func changeProfile(_ change: Bool) {
        view.saveButton(isShow: change)
    }

    func toLogin() {
        router?.loginUser()
    }
}
