//
//  NewPostInteractor.swift
//  Lenta
//
//  Created by Алексей Алексеев on 06.07.2021.
//

import Foundation

protocol NewPostInteractorInput {
    func sendPost(description: String, image: Data?)
}

final class NewPostInteractor {

    // MARK: - Properties

    weak var presenter: NewPostInteractorOutput?
    var networkManager: NetworkManagerProtocol?
    var storageManager: StorageManagerProtocol?

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

    func sendPost(description: String, image: Data?) {
        guard let currentUser = storageManager?.getCurrenUserFromUserDefaults() else { return }
        let sendPost = SendPost(userId: currentUser.id, description: description, imageData: image)
        networkManager?.sendPost(post: sendPost) { [weak self] result in
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
