//
//  NewPostPresenterSpy.swift
//  LentaTests
//
//  Created by Алексей Алексеев on 17.07.2021.
//

import Foundation
@testable import Lenta

final class NewPostPresenterSpy: NewPostInteractorOutput {
    
    var newPostSendFailedCallCount = 0
    var newPostSendSuccessCallCount = 0
    
    var recivedError: NetworkServiceError?
    var recivedResponse: Response?
    
    func newPostSendFailed(serviceError: NetworkServiceError) {
        newPostSendFailedCallCount += 1
        recivedError = serviceError
    }
    
    func newPostSendSuccess(response: Response) {
        newPostSendSuccessCallCount += 1
        recivedResponse = response
    }
}
