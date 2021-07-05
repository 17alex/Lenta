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
    
    func startController() -> UIViewController {
        return getTabBarController()
    }
    
    func getTabBarController() -> UIViewController {
        let tbController = UITabBarController()
        
        let lenta = UINavigationController(rootViewController: getLentaModule())
        lenta.tabBarItem.title = "Lenta"
        lenta.tabBarItem.image = UIImage(systemName: "scribble")
        
        let profile = UINavigationController(rootViewController: getProfileModule())
        profile.tabBarItem.title = "Profile"
        profile.tabBarItem.image = UIImage(systemName: "person")
        
        tbController.viewControllers = [lenta, profile]
        
        return tbController
    }
    
    func getUserInfoModule(user: UserViewModel) -> UIViewController {
        let view = UserInfoViewController()
        view.user = user
        return view
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
        let router = LentaRouter(view: view, assembly: self)
        let interactor = LentaInteractor()
        let presenter = LentaPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        interactor.networkManager = networkManager
        interactor.storeManager = storeManager
        return view
    }
    
    func getNewPostModule(callback: @escaping (Response) -> Void) -> UIViewController {
        let view = NewPostViewController()
        let presenter = NewPostPresenter(view: view, callback: callback)
        let router = NewPostRouter(view: view, assembly: self)
        view.presenter = presenter
        presenter.storeManager = storeManager
        presenter.networkManager = networkManager
        presenter.router = router
        return view
    }
    
    func getCommentsModule(by postId: Int16) -> UIViewController {
        let view = CommentsViewController()
        let router = CommentsRouter(view: view, assembly: self)
        let interactor = CommentsInteractor()
        let presenter = CommentsPresenter(view: view, interactor: interactor, postId: postId)
        view.presenter = presenter
        presenter.router = router
        interactor.presenter = presenter
        interactor.networkManager = networkManager
        interactor.storeManager = storeManager
        return view
    }
}
