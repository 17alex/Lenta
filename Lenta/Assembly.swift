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
    var navigationController: UINavigationController!
    
    init() { print("Assembly init") }
    
    deinit { print("Assembly deinit") }
    
    func start() -> UIViewController {
        navigationController = UINavigationController(rootViewController: getLentaModule())
        return navigationController
    }
    
    func getRegisterModule(complete: @escaping (CurrentUser) -> Void) -> UIViewController {
        let view = RegisterViewController()
        let presenter = RegisterPresenter(view: view)
        let router = RegisterRouter(assembly: self, view: view, complete: complete)
        presenter.router = router
        view.presenter = presenter
        return view
    }
    
    func getLoginModule(complete: @escaping (CurrentUser) -> Void) -> UIViewController {
        let view = LoginViewController()
        let presenter = LoginPresenter(view: view)
        let interactor = LoginInteractor(presenter: presenter)
        let router = LoginRouter(assembly: self, view: view, complete: complete)
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
        let router = LentaRouter(view: view, assembly: self)
        
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
        let router = NewPostRouter(view: view, assembly: self)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        interactor.networkManager = networkManager
        return view
    }
}
