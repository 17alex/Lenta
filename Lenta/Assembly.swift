//
//  Assembly.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

class Assembly {
    
    let networkManager = NetworkManager()
    let storeManager = StoreManager()
    
    init() { print("Assembly init") }
    
    deinit { print("Assembly deinit") }
    
    func start() -> UIViewController {
        return UINavigationController(rootViewController: getLentaModule())
    }
    
    func getLoginModule(complete: @escaping (CurrentUser) -> Void) -> UIViewController {
        let view = LoginViewController()
        let presenter = LoginPresenter(view: view)
        let interactor = LoginInteractor(presenter: presenter)
        let router = LoginRouter(view: view, complete: complete)
        presenter.router = router
        presenter.interactor = interactor
        interactor.networkManager = networkManager
        view.presenter = presenter
        return view
    }
    
    func getLentaModule() -> UIViewController {
        let view = LentaViewController()
        let presenter = LentaPresenter(view: view)
        let interactor = LentaInteractor(presenter: presenter)
        let router = LentaRouter(assembly: self)
        router.view = view
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        interactor.networkManager = networkManager
        interactor.storeManager = storeManager
        return view
    }
    
    func getNewPostModule(for user: CurrentUser) -> UIViewController {
        let view = NewPostViewController()
        let presenter = NewPostPresenter(currentUser: user, view: view)
        let interactor = NewPostInteractor(presenter: presenter)
        let router = NewPostRouter(assembly: self)
        router.view = view
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        interactor.networkManager = networkManager
        return view
    }
}
