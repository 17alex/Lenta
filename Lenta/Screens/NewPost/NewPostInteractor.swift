//
//  NewPostInteractor.swift
//  Lenta
//
//  Created by Алексей Алексеев on 06.07.2021.
//

import UIKit

protocol NewPostInteractorInput {
    func sendPost(description: String, image: UIImage?)
}

final class NewPostInteractor {

    // MARK: - Propertis

    weak var presenter: NewPostInteractorOutput?
    var networkManager: NetworkManagerProtocol?
    var storeManager: StoreManagerProtocol?

    // MARF: - Init

    init() {
        print("NewPostInteractor init")
    }

    deinit {
        print("NewPostInteractor deinit")
    }

}

// MARK: - NewPostInteractorInput

extension NewPostInteractor: NewPostInteractorInput {

    func sendPost(description: String, image: UIImage?) {
        guard let currentUser = storeManager?.getCurrenUser() else { return }
        let sendPost = SendPost(userId: currentUser.id, description: description, image: image)
        networkManager?.sendPost(post: sendPost) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let serviceError):
                self.presenter?.newPostSendFailed(serviceError: serviceError)
            case .success(let response):
                self.presenter?.newPostSendSuccess(response: response)
            }
        }
    }

}
