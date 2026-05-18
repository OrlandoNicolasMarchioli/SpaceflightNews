//
//  SpaceflightNewsUITestsLaunchTests.swift
//  SpaceflightNewsUITests
//
//  Created by Orlando Nicola Marchioli on 16/05/2026.
//

import XCTest

final class SpaceflightNewsUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
