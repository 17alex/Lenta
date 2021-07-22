//
//  ProfilePresenterSpy.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 22.07.2021.
//

import Foundation
@testable import Lenta

final class ProfilePresenterSpy: ProfileInteractorOutput {

    var currentUserCallCoutn = 0
    var changeProfileCallCount = 0
    var toLoginCallCount = 0
    var saveProfileSuccessCallCount = 0
    var saveProfileFailedCallCount = 0

    var recivedUser: User?
    var recivedProfileChangeValue: Bool?
    var recivedServiceError: NetworkServiceError?

    func saveProfileFailed(serviceError: NetworkServiceError) {
        saveProfileFailedCallCount += 1
        recivedServiceError = serviceError
    }

    func saveProfileSuccess() {
        saveProfileSuccessCallCount += 1
    }

    func saveProfileError() {
        fatalError()
    }

    func currentUser(currentUser: User?) {
        currentUserCallCoutn += 1
        recivedUser = currentUser
    }

    func changeProfile(_ change: Bool) {
        changeProfileCallCount += 1
        recivedProfileChangeValue = change
    }

    func toLogin() {
        toLoginCallCount += 1
    }
}
