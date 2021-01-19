//
//  NewPostPresenter.swift
//  Lenta
//
//  Created by Alex on 14.01.2021.
//

import UIKit

protocol NewPostViewOutput {
    func pressSendWith(description: String, image: UIImage?)
}

protocol NewPostInteractorOutput: class {
    func postSaved(_ postSaved: Bool)
}

class NewPostPresenter {
    
    unowned let view: NewPostViewInput
    var interactor: NewPostInteractorInput!
    var router: NewPostRouterInput!
    let currentUser: CurrentUser
    
    init(currentUser: CurrentUser, view: NewPostViewInput) {
        print("NewPostPresenter init")
        self.currentUser = currentUser
        self.view = view
    }
    
    deinit {
        print("NewPostPresenter deinit")
    }
}

extension NewPostPresenter: NewPostViewOutput {
    func pressSendWith(description: String, image: UIImage?) {
        let sendPost = SendPost(userId: currentUser.id, description: description, image: image)
        interactor.sendPost(post: sendPost)
    }
    
}

extension NewPostPresenter: NewPostInteractorOutput {
    
    func postSaved(_ postSaved: Bool) {
        if postSaved {
            router.dismiss()
        } else {
            view.notSavedPost()
        }
    }
}
