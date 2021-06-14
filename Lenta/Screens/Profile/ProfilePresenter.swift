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
    
    //MARK: - Propertis
    
    unowned private let view: ProfileViewInput
    var storeManager: StoreManagerProtocol!
    var networkManager: NetworkManagerProtocol!
    var router: ProfileRouterInput!
    
    var currentUser: CurrentUser? {
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
    
    //MARK: - Init
    
    init(view: ProfileViewInput) {
        self.view = view
        print("ProfilePresenter init")
    }
    
    deinit {
        print("ProfilePresenter deinit")
    }
    
    //MARK: - Metods
    
    private func changeProfile() {
        guard let currUser = currentUser  else { view.didChangeProfile(false); return }
        if !newName.isEmpty && (newName != currUser.name || isSetNewAvatar) {
            view.didChangeProfile(true)
        } else {
            view.didChangeProfile(false)
        }
    }
}

//MARK: - ProfileViewOutput

extension ProfilePresenter: ProfileViewOutput {
    
    func saveButtonPress(name: String, image: UIImage?) {
        var avatarImage: UIImage?
        if isSetNewAvatar {
            avatarImage = image
        }
        
        guard let currUser = currentUser else { return }
        networkManager.updateProfile(id: currUser.id, name: name, avatar: avatarImage) { (result) in
            switch result {
            case .failure(let error):
                self.view.showMessage(error.localizedDescription)
            case .success(let users):
                if let user = users.first {
                    let currentUser = CurrentUser(id: user.id, name: user.name, postsCount: user.postsCount, dateRegister: user.dateRegister, avatar: user.avatar)
                    self.currentUser = currentUser
                    self.storeManager.save(currentUser)
                    self.view.showMessage("update successfull")
                    self.isSetNewAvatar = false
                } else {
                    self.view.showMessage("error update")
                }
            }
        }
    }
    
    func logInOutButtonPress() {
        if currentUser == nil {
            router.loginUser()
        } else {
            currentUser = nil
            storeManager.save(currentUser)
            view.userLoginned(CurrentUserModel(currentUser: currentUser))
        }
    }
    
    func didSelectNewAvatar() {
        isSetNewAvatar = true
    }
    
    func change(name: String) {
        self.newName = name
    }
    
    func start() {
        currentUser = storeManager.getCurrenUser()
        view.userLoginned(CurrentUserModel(currentUser: currentUser))
    }
}
