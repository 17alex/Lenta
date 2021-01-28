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
    
    func getProfileModule() -> UIViewController {
        let view = ProfileViewController()
        let presenter = ProfilePresenter(view: view)
        let router = ProfileRouter(view: view, assembly: self)
        presenter.router = router
        presenter.networkManager = networkManager
        presenter.storeManager = storeManager
        view.presenter = presenter
        return view
    }
    
    func getMenuModule() -> UIViewController {
        let view = MenuViewController()
        let presenter = MenuPresenter(view: view)
        let router = MenuRouter(view: view, assembly: self)
        presenter.router = router
        presenter.storeManager = storeManager
        view.presenter = presenter
        return view
    }
    
    func getRegisterModule() -> UIViewController {
        let view = RegisterViewController()
        let presenter = RegisterPresenter(view: view)
        let interactor = RegisterInteractor(presenter: presenter)
        let router = RegisterRouter(assembly: self, view: view)
        presenter.router = router
        presenter.interactor = interactor
        interactor.networkManager = networkManager
        interactor.storeManager = storeManager
        view.presenter = presenter
        return view
    }
    
    func getLoginModule() -> UIViewController {
        let view = LoginViewController()
        let presenter = LoginPresenter(view: view)
        let interactor = LoginInteractor(presenter: presenter)
        let router = LoginRouter(assembly: self, view: view)
        presenter.router = router
        presenter.interactor = interactor
        interactor.networkManager = networkManager
        interactor.storeManager = storeManager
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
