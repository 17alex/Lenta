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
    var recivedError: NetworkServiceError?

    func userDidRegistered() {
        userDidRegisterCount += 1
    }

    func userDidRegisteredFail(error: NetworkServiceError) {
        userRegisterFailCount += 1
        self.recivedError = error
    }
}
