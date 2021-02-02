//
//  NewPostPresenter.swift
//  Lenta
//
//  Created by Alex on 14.01.2021.
//

import UIKit

protocol NewPostViewOutput {
    func viewDidLoad()
    func pressSendWith(description: String, image: UIImage?)
}

class NewPostPresenter {
    
    unowned let view: NewPostViewInput
    var networkManager: NetworkManagerProtocol!
    var storeManager: StoreManagerProtocol!
    var router: NewPostRouterInput!
    
    var currentUser: CurrentUser!
    
    init(view: NewPostViewInput) {
        print("NewPostPresenter init")
        self.view = view
    }
    
    deinit {
        print("NewPostPresenter deinit")
    }
}

extension NewPostPresenter: NewPostViewOutput {
    
    func viewDidLoad() {
        currentUser = storeManager.getCurrenUser()!
    }
    
    func pressSendWith(description: String, image: UIImage?) {
        let sendPost = SendPost(userId: currentUser.id, description: description, image: image)
        networkManager.sendPost(post: sendPost) { (result) in
            switch result {
            case .failure(let error):
                self.view.notSavedPost(text: error.localizedDescription)
            case .success(let response):
                self.router.dismiss()
            }
        }
    }
}
