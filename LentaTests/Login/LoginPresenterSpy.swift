//
//  LoginPresenterSpy.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 03.07.2021.
//

import Foundation
@testable import Lenta

final class LoginPresenterSpy: LoginInteractorOutput {
    
    var userDidLoginedCount = 0
    var userLoginFailCount = 0
    var message = ""
    
    func userDidLogined() {
        userDidLoginedCount += 1
    }
    
    func userLoginFail(message: String) {
        userLoginFailCount += 1
        self.message = message
    }
}
