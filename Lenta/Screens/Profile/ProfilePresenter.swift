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

final class ProfilePresenter {
    
    unowned let view: ProfileViewInput
    var storeManager: StoreManagerProtocol!
    var networkManager: NetworkManagerProtocol!
    var router: ProfileRouterInput!
    
    var currentUser: CurrentUser? {
        didSet {
            if let user = currentUser {
                name = user.name
            } else {
                name = ""
            }
        }
    }
    
    var isNewAvatar = false {
        didSet {
            changeProfile()
        }
    }
    
    var name = "" {
        didSet {
            changeProfile()
        }
    }
    
    init(view: ProfileViewInput) {
        self.view = view
        print("ProfilePresenter init")
    }
    
    deinit {
        print("ProfilePresenter deinit")
    }
    
    private func changeProfile() {
        if let user = currentUser {
            if !name.isEmpty && (name != user.name || isNewAvatar) {
                view.didChangeProfile(true)
            } else {
                view.didChangeProfile(false)
            }
        } else {
            view.didChangeProfile(false)
        }
    }
}

extension ProfilePresenter: ProfileViewOutput {
    
    func saveButtonPress(name: String, image: UIImage?) {
        var avatarImage: UIImage?
        if isNewAvatar {
            avatarImage = image
        }
        if let currUser = currentUser {
            networkManager.updateProfile(id: currUser.id, name: name, avatar: avatarImage) { (result) in
                switch result {
                case .failure(let error):
                    self.view.didUpdateProfile(message: error.localizedDescription)
                case .success(let users):
                    if let user = users.first {
                        let currentUser = CurrentUser(id: user.id, name: user.name, avatarName: user.avatarName)
                        self.currentUser = currentUser
                        self.storeManager.save(currentUser)
                        self.view.didUpdateProfile(message: "update successfull")
                        self.isNewAvatar = false
                    } else {
                        self.view.didUpdateProfile(message: "error update")
                    }
                }
            }
        }
    }
    
    func logInOutButtonPress() {
        if currentUser != nil {
            currentUser = nil
            storeManager.save(currentUser)
            view.userLoginned(currentUser)
        } else {
            router.loginUser()
        }
    }
    
    func didSelectNewAvatar() {
        isNewAvatar = true
    }
    
    func change(name: String) {
        self.name = name
    }
    
    func start() {
        currentUser = storeManager.getCurrenUser()
        view.userLoginned(currentUser)
    }
    
}
