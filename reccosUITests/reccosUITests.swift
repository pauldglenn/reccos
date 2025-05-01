//
//  reccosUITests.swift
//  reccosUITests
//
//  Created by Paul Glenn on 4/28/25.
//

import XCTest

final class reccosUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    @MainActor
    func testAddRecommendation() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Tap the Add button
        app.buttons["Add Button"].tap()
        
        // Enter search text and select type
        let searchField = app.textFields["Search Field"]
        searchField.tap()
        searchField.typeText("Test Podcast")
        
        app.buttons["Content Type Picker"].tap()
        app.buttons["Content Type podcast"].tap()
        
        // Fill in title
        let titleField = app.textFields["Title Field"]
        titleField.tap()
        titleField.typeText("Test Podcast Title")
        
        // Fill in recommender
        let recommenderField = app.textFields["Recommender Field"]
        recommenderField.tap()
        recommenderField.typeText("Test User")
        
        app.swipeUp()
        
        // Now try to tap and fill in notes
        let notesField = app.textFields["Notes Field"]
        notesField.tap()
        notesField.typeText("Test notes")
        
        // Save the recommendation
        app.buttons["Save Button"].tap()
    }

    @MainActor
    func testFilterRecommendation() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Add a recommendation first
        app.buttons["Add Button"].tap()
        
        let searchField = app.textFields["Search Field"]
        searchField.tap()
        searchField.typeText("Test Podcast")
        
        app.buttons["Content Type Picker"].tap()
        app.buttons["Content Type podcast"].tap()
        
        // Fill in title
        let titleField = app.textFields["Title Field"]
        titleField.tap()
        titleField.typeText("Test Podcast Title")
        
        let recommenderField = app.textFields["Recommender Field"]
        recommenderField.tap()
        recommenderField.typeText("Test User")
        
        app.swipeUp()
        
        // Now try to tap and fill in notes
        let notesField = app.textFields["Notes Field"]
        notesField.tap()
        notesField.typeText("Test notes")
        
        app.buttons["Save Button"].tap()
        
        // Now test filtering
        app.buttons["Filter Button"].tap()
        
        // Filter by podcasts
        app.buttons["Content Type, All"].tap()
        app.buttons["Podcasts"].tap()
        
        app.swipeDown(velocity: 2500)
        Thread.sleep(forTimeInterval: 0.5)
        
        // Verify the recommendation is visible
        XCTAssertTrue(app.buttons["Content Row Test Podcast Title"].exists)
        
        // Filter by movies (should not show the podcast)
        app.buttons["Filter Button"].tap()
        app.buttons["Content Type, Podcasts"].tap()
        app.buttons["Movies"].tap()
        app.swipeDown(velocity: 2500)
        Thread.sleep(forTimeInterval: 0.5)
        
        // Verify the recommendation is not visible
        XCTAssertFalse(app.buttons["Content Row Test Podcast"].exists)
    }
}

// Add extension to help with scrolling
extension XCUIApplication {
    func scrollToElement(element: XCUIElement) {
        while !element.isHittable {
            swipeUp()
        }
    }
}
