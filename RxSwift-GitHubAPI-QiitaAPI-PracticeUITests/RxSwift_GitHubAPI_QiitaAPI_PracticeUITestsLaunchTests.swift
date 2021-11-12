//
//  RxSwift_GitHubAPI_QiitaAPI_PracticeUITestsLaunchTests.swift
//  RxSwift-GitHubAPI-QiitaAPI-PracticeUITests
//
//  Created by 大西玲音 on 2021/11/12.
//

import XCTest

class RxSwift_GitHubAPI_QiitaAPI_PracticeUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
