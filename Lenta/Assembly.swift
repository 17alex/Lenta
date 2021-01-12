//
//  Assembly.swift
//  Lenta
//
//  Created by Alex on 11.01.2021.
//

import UIKit

class Assembly {
    
    init() { print("Assembly init") }
    
    deinit { print("Assembly deinit") }
    
    func getLentaModule() -> UIViewController {
        let view = LentaViewController()
        let presenter = LentaPresenter(view: view)
        let interactor = LentaInteractor(presenter: presenter)
        let router = LentaRouter(assembly: self)
        let networkManager = NetworkManager()
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        interactor.networkManager = networkManager
        return view
    }
}
