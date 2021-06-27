//
//  NewPostPresenter.swift
//  Lenta
//
//  Created by Alex on 14.01.2021.
//

import UIKit

protocol NewPostViewOutput {
    func pressSendButton(description: String, image: UIImage?)
}

final class NewPostPresenter {
    
    unowned private let view: NewPostViewInput
    var networkManager: NetworkManagerProtocol!
    var storeManager: StoreManagerProtocol!
    var router: NewPostRouterInput!
    let callback: (Response) -> Void
    
    //MARK: - Init
    
    init(view: NewPostViewInput, callback: @escaping (Response) -> Void) {
        self.view = view
        self.callback = callback
        print("NewPostPresenter init")
    }
    
    deinit {
        print("NewPostPresenter deinit")
    }
}

//MARK: - NewPostViewOutput

extension NewPostPresenter: NewPostViewOutput {
        
    func pressSendButton(description: String, image: UIImage?) {
        guard let currentUser = storeManager.getCurrenUser() else { return }
        let sendPost = SendPost(userId: currentUser.id, description: description, image: image)
        networkManager.sendPost(post: sendPost) { (result) in
            switch result {
            case .failure(let serviceError):
                self.view.newPostSendFailed(text: serviceError.rawValue)
            case .success(let response):
                self.callback(response)
                self.router.dismiss()
            }
        }
    }
}
