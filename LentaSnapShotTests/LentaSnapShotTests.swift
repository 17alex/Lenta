//
//  LentaSnapShotTests.swift
//  LentaSnapShotTests
//
//  Created by Алексей Алексеев on 09.07.2021.
//

import SnapshotTesting
import XCTest
@testable import Lenta

class LentaSnapShotTests: XCTestCase {

    func testRegisterVC() throws {
        let regVC = Assembly().getRegisterModule()

//        isRecording = true
        assertSnapshot(matching: regVC, as: .image(on: .iPhone8))
    }
}
