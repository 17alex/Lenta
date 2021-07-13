//
//  Assembly.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

final class Assembly {

    // MARK: - Propertis

    private let networkManager = NetworkManager()
    private let storeManager = StoreManager()

    // MARK: - Init

    init() {
        print("Assembly init")
    }

    deinit {
        print("Assembly deinit")
    }

    // MARK: - Metods

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
        let router = UserInfoRouter(view: view, assembly: self)
        let interactor = UserInfoInteractor()
        let presenter = UserInfoPresenter(view: view, router: router, user: user)
        presenter.interactor = interactor
        interactor.networkManager = networkManager
        view.presenter = presenter
        return view
    }

    func getProfileModule() -> UIViewController {
        let view = ProfileViewController()
        let router = ProfileRouter(view: view, assembly: self)
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter(view: view, interactor: interactor)
        presenter.router = router
        interactor.presenter = presenter
        interactor.networkManager = networkManager
        interactor.storeManager = storeManager
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
        let router = NewPostRouter(view: view, assembly: self)
        let interactor = NewPostInteractor()
        let presenter = NewPostPresenter(view: view, interactor: interactor, callback: callback)
        view.presenter = presenter
        interactor.presenter = presenter
        interactor.storeManager = storeManager
        interactor.networkManager = networkManager
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
