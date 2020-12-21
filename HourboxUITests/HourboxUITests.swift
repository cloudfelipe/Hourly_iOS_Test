//
//  HourboxUITests.swift
//  HourboxUITests
//
//  Created by Felipe Correa on 14/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import XCTest

class HourboxUITests: XCTestCase {

    func testFlows() {
        
        let app = XCUIApplication()
        continueAfterFailure = false
        app.launchArguments = ["UITestMode"]
        app.launch()
        
        // Test Image Viewer
        let collectionViewsQuery = app.collectionViews
        let cell = collectionViewsQuery.children(matching: .cell).element(boundBy: 0)
        cell.children(matching: .other).element.children(matching: .other).element.tap()
        app.buttons["Close"].tap()
        
        //Test Pdf viewer
        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        let homeNavigationBar = app.navigationBars["Home"]
        homeNavigationBar.buttons["Home"].tap()
        
        //Test go to file Information
        cell.buttons["More Info"].tap()
        app.navigationBars["File information"].buttons["Home"].tap()
        
        // Test go to file directory
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        
        app.navigationBars["/sample"].buttons["Home"].tap()
        
        //Test logout
        homeNavigationBar.buttons["Log out"].tap()
        
        //Test sign in
        app.alerts["Session expired"].scrollViews.otherElements.buttons["Ok"].tap()
        app.buttons["Sign In"].tap()
        app.otherElements["TopBrowserBar"].children(matching: .button).element(boundBy: 1).children(matching: .other).element.tap()
                
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
