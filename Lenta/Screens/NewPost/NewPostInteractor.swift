//
//  NewPostInteractor.swift
//  Lenta
//
//  Created by Alex on 14.01.2021.
//

import Foundation

protocol NewPostInteractorInput {
    func sendPost(post: SendPost)
}

class NewPostInteractor {
    
    unowned let presenter: NewPostInteractorOutput
    var networkManager: NetworkManagerProtocol!
    
    init(presenter: NewPostInteractorOutput) {
        print("NewPostInteractor init")
        self.presenter = presenter
    }
    
    deinit { print("NewPostInteractor deinit") }
    
}

extension NewPostInteractor: NewPostInteractorInput {
    func sendPost(post: SendPost) {
        networkManager.setPost(post: post)
    }
}
