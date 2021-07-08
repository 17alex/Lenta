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
    
    //MARK: - Propertis
    
    unowned private let view: ProfileViewInput
    private let interactor: ProfileInteractorInput
    var router: ProfileRouterInput?
    
    //MARK: - Init
    
    init(view: ProfileViewInput, interactor: ProfileInteractorInput) {
        self.view = view
        self.interactor = interactor
        print("ProfilePresenter init")
    }
    
    deinit {
        print("ProfilePresenter deinit")
    }
}

//MARK: - ProfileViewOutput

extension ProfilePresenter: ProfileViewOutput {
    
    func saveButtonPress(name: String, image: UIImage?) {
        interactor.saveProfile(name: name, image: image)
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

//MARK: - ProfileInteractorOutput

extension ProfilePresenter: ProfileInteractorOutput {
    
    func saveProfileFailed(serviceError: NetworkServiceError) {
        view.showMessage(serviceError.rawValue)
    }
    
    func saveProfileSuccess() {
        view.showMessage("update successfull")
    }
    
    func saveProfileError() {
        view.showMessage("error update")
    }
    
    func currentUser(currentUser: User?) {
        view.userLoginned(UserViewModel(user: currentUser))
    }
    
    func changeProfile(_ change: Bool) {
        view.didChangeProfile(change)
    }
    
    func toLogin() {
        router?.loginUser()
    }
}
