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

protocol NewPostInteractorOutput: AnyObject {
    func newPostSendFailed(serviceError: NetworkServiceError)
    func newPostSendSuccess(response: Response)
}

final class NewPostPresenter {

    // MARK: - Properties

    unowned private let view: NewPostViewInput
    private let interactor: NewPostInteractorInput
    var router: NewPostRouterInput?
    let callback: (Response) -> Void

    // MARK: - Init

    init(view: NewPostViewInput, interactor: NewPostInteractorInput, callback: @escaping (Response) -> Void) {
        self.view = view
        self.callback = callback
        self.interactor = interactor
        print("NewPostPresenter init")
    }

    deinit {
        print("NewPostPresenter deinit")
    }
}

// MARK: - NewPostViewOutput

extension NewPostPresenter: NewPostViewOutput {

    func pressSendButton(description: String, image: UIImage?) {
        var imageData: Data?
        if let image = image {
            imageData = image.jpegData(compressionQuality: 0.25)
        }
        interactor.sendPost(description: description, image: imageData)
    }
}

// MARK: - NewPostInteractorOutput

extension NewPostPresenter: NewPostInteractorOutput {

    func newPostSendFailed(serviceError: NetworkServiceError) {
        view.newPostSendFailed(text: serviceError.rawValue)
    }

    func newPostSendSuccess(response: Response) {
        callback(response)
        router?.dismiss()
    }
}
