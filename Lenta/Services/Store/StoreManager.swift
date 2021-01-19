//
//  StoreManager.swift
//  Lenta
//
//  Created by Alex on 18.01.2021.
//

import Foundation

protocol StoreManagerProtocol {
    func getCurrenUser() -> CurrentUser?
    func saveCurrentUser(_ user: CurrentUser)
}

class StoreManager {
    
    let storeKey = "userStoreKey"
    
}

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
    
    func saveCurrentUser(_ user: CurrentUser) {
        let userData = try! JSONEncoder().encode(user)
        UserDefaults.standard.setValue(userData, forKey: storeKey)
    }
}
