//
//  ProfileInteractor.swift
//  Lenta
//
//  Created by Алексей Алексеев on 06.07.2021.
//

import Foundation

protocol ProfileInteractorInput {
    func saveProfile(name: String, image: Data?)
    func start()
    func didSelectNewAvatar()
    func change(name: String)
    func logInOutButtonPress()
    func getImage(from urlString: String?, completion: @escaping (Data?) -> Void)
}

final class ProfileInteractor {

    // MARK: - Properties

    var storageManager: StorageManagerProtocol?
    var networkManager: NetworkManagerProtocol?
    weak var presenter: ProfileInteractorOutput?

    var currentUserId: Int16? {
        didSet {
            if let userId = currentUserId {
                newName = storageManager.getUser(for: userId).name
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

    // MARK: - Init

    init() {
        print("ProfileInteractor init")
    }

    deinit {
        print("ProfileInteractor deinit")
    }

    // MARK: - Methods

    private func changeProfile() {
        guard let currUser = currentUser  else { presenter?.changeProfile(false); return }
        presenter?.changeProfile(!newName.isEmpty && (newName != currUser.name || isSetNewAvatar))
    }
}

// MARK: - ProfileInteractorInput

extension ProfileInteractor: ProfileInteractorInput {

    func getImage(from urlString: String?, completion: @escaping (Data?) -> Void) {
        networkManager?.loadImage(from: urlString, completion: completion)
    }

    func start() {
        currentUserId = storageManager?.getCurrenUserId()
//        currentUser = storageManager?.getCurrenUser()
        let currentUser = storageManager.loadUser(id: currentUserId)
        presenter?.currentUser(currentUser: currentUser)
    }

    func didSelectNewAvatar() {
        isSetNewAvatar = true
    }

    func change(name: String) {
        self.newName = name
    }

    func logInOutButtonPress() {
        if currentUserId == nil {
            presenter?.toLogin()
        } else {
            currentUserId = nil
            storageManager?.save(user: currentUser)
            presenter?.currentUser(currentUser: currentUser)
        }
    }

    func saveProfile(name: String, image: Data?) {
        var avatarImage: Data?
        if isSetNewAvatar {
            avatarImage = image
        }

        guard let currUserId = currentUserId else { return }
        networkManager?.updateProfile(userId: currUserId, name: name, avatar: avatarImage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.presenter?.saveProfileFailed(serviceError: error)
            case .success(let users):
                if let user = users.first {
                    self.currentUserId = user.id
                    self.storageManager?.saveCurrentUserId(userId: user.id)
                    self.storageManager?.save(user: user)
                    self.presenter?.saveProfileSuccess()
                    self.isSetNewAvatar = false
                } else {
                    self.presenter?.saveProfileError()
                }
            }
        }
    }
}
