//
//  ProfileInteractor.swift
//  Lenta
//
//  Created by Алексей Алексеев on 06.07.2021.
//

import UIKit

protocol ProfileInteractorInput {
    func saveProfile(name: String, image: UIImage?)
    func start()
    func didSelectNewAvatar()
    func change(name: String)
    func logInOutButtonPress()
    func getImage(from urlString: String?, complete: @escaping (UIImage?) -> Void)
}

final class ProfileInteractor {

    // MARK: - Propertis

    var storeManager: StoreManagerProtocol?
    var networkManager: NetworkManagerProtocol?
    weak var presenter: ProfileInteractorOutput?

    var currentUser: User? {
        didSet {
            if let user = currentUser {
                newName = user.name
            } else {
                newName = ""
            }
        }
    }

    var isSetNewAvatar = false {
        didSet {
            changeProfile()
        }
    }

    var newName = "" {
        didSet {
            changeProfile()
        }
    }

    // MARK: - Metods

    private func changeProfile() {
        guard let currUser = currentUser  else { presenter?.changeProfile(false); return }
        presenter?.changeProfile(!newName.isEmpty && (newName != currUser.name || isSetNewAvatar))
    }
}

// MARK: - ProfileInteractorInput

extension ProfileInteractor: ProfileInteractorInput {

    func getImage(from urlString: String?, complete: @escaping (UIImage?) -> Void) {
        networkManager?.loadImage(from: urlString, complete: complete)
    }

    func start() {
        currentUser = storeManager?.getCurrenUser()
        presenter?.currentUser(currentUser: currentUser)
    }

    func didSelectNewAvatar() {
        isSetNewAvatar = true
    }

    func change(name: String) {
        self.newName = name
    }

    func logInOutButtonPress() {
        if currentUser == nil {
            presenter?.toLogin()
        } else {
            currentUser = nil
            storeManager?.save(user: currentUser)
            presenter?.currentUser(currentUser: currentUser)
        }
    }

    func saveProfile(name: String, image: UIImage?) {
        var avatarImage: UIImage?
        if isSetNewAvatar {
            avatarImage = image
        }

        guard let currUser = currentUser else { return }
        networkManager?.updateProfile(userId: currUser.id, name: name, avatar: avatarImage) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.presenter?.saveProfileFailed(serviceError: error)
            case .success(let users):
                if let user = users.first {
                    self.currentUser = user
                    self.storeManager?.save(user: self.currentUser)
                    self.presenter?.saveProfileSuccess()
                    self.isSetNewAvatar = false
                } else {
                    self.presenter?.saveProfileError()
                }
            }
        }
    }
}
