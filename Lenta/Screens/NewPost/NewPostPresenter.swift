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
    
}

class NewPostPresenter {
    
    unowned let view: NewPostViewInput
    var interactor: NewPostInteractorInput!
    var router: NewPostRouterInput!
    
    init(view: NewPostViewInput) {
        print("NewPostPresenter init")
        self.view = view
    }
    
    deinit { print("NewPostPresenter deinit") }
}

extension NewPostPresenter: NewPostViewOutput {
    func pressSendWith(description: String, image: UIImage?) {
        let sendPost = SendPost(description: description, image: image)
        interactor.sendPost(post: sendPost)
    }
    
}

extension NewPostPresenter: NewPostInteractorOutput {
    
}
