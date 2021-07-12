//
//  RegisterPresenetrSpy.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 03.07.2021.
//

import Foundation
@testable import Lenta

final class RegisterPresenterSpy: RegisterInteractorOutput {

    var userDidRegisterCount = 0
    var userRegisterFailCount = 0
    var message = ""

    func userDidRegistered() {
        userDidRegisterCount += 1
    }

    func userDidRegisteredFail(message: String) {
        userRegisterFailCount += 1
        self.message = message
    }
}
