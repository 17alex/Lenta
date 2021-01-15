//
//  Assembly.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

class Assembly {
    
    let networkManager = NetworkManager()
    
    init() { print("Assembly init") }
    
    deinit { print("Assembly deinit") }
    
    func start() -> UIViewController {
        return UINavigationController(rootViewController: getLentaModule())
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
        return view
    }
    
    func getNewPostModule() -> UIViewController {
        let view = NewPostViewController()
        let presenter = NewPostPresenter(view: view)
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
