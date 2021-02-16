//
//  StoreManager.swift
//  Lenta
//
//  Created by Alex on 18.01.2021.
//

import Foundation

protocol StoreManagerProtocol {
    func getCurrenUser() -> CurrentUser?
    func save(_ user: CurrentUser?)
}

class StoreManager {
    
    private let storeKey = "userStoreKey"
}

//MARK: - StoreManagerProtocol

extension StoreManager: StoreManagerProtocol {
    
    func getCurrenUser() -> CurrentUser? {
        if let userData = UserDefaults.standard.data(forKey: storeKey),
           let currentUser = try? JSONDecoder().decode(CurrentUser.self, from: userData) {
            print("user in store = \(currentUser)")
            return currentUser
        } else {
            print("user in store is NOT")
            return nil
        }
    }
    
    func save(_ user: CurrentUser?) {
        var data: Data?
        if let user = user, let userData = try? JSONEncoder().encode(user) {
            data = userData
        }
        
        UserDefaults.standard.setValue(data, forKey: storeKey)
    }
}
