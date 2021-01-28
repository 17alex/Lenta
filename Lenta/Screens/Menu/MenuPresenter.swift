//
//  SettingsPresenter.swift
//  Lenta
//
//  Created by Alex on 27.01.2021.
//

import Foundation

enum MenuItems: String {
    case settings = "Settings"
    case prifile = "Profile"
    case about = "About"
}

protocol MenuViewOutput {
    var menuTitles: [String] { get }
    func didPress(for row: Int)
}

class MenuPresenter {
    
    unowned let view: MenuViewInput
    var router: MenuRouterInput!
    var storeManager: StoreManager!
    
    private let menuItems: [MenuItems] = [.settings, .prifile, .about]
    
    private lazy var menuStrings: [String] = {
        var mnuStrings: [String] = []
        for item in menuItems {
            mnuStrings.append(item.rawValue)
        }
        return mnuStrings
    }()
    
    init(view: MenuViewInput) {
        print("MenuPresenter init")
        self.view = view
    }
    
    deinit {
        print("MenuPresenter deinit")
    }
}

extension MenuPresenter: MenuViewOutput {
    
    func didPress(for row: Int) {
        switch menuItems[row] {
        case .settings: break
        case .prifile: router.showProfileModule()
        case .about: break
        }
    }
    
    var menuTitles: [String] {
        return menuStrings
    }
}
