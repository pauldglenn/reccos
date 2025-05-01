import XCTest
@testable import reccos

final class ContentTests: XCTestCase {
    func testContentInitialization() {
        let content = Content(
            title: "Test Title",
            type: .movie,
            recommender: "John Doe",
            notes: "Great movie!",
            externalId: "123",
            source: "IMDB"
        )
        
        XCTAssertEqual(content.title, "Test Title")
        XCTAssertEqual(content.type, .movie)
        XCTAssertEqual(content.recommender, "John Doe")
        XCTAssertEqual(content.notes, "Great movie!")
        XCTAssertEqual(content.externalId, "123")
        XCTAssertEqual(content.source, "IMDB")
        XCTAssertNotNil(content.id)
        XCTAssertNotNil(content.creationDate)
        XCTAssertNotNil(content.modificationDate)
    }
    
    func testContentWithoutOptionalFields() {
        let content = Content(
            title: "Test Title",
            type: .movie,
            recommender: "John Doe"
        )
        
        XCTAssertEqual(content.title, "Test Title")
        XCTAssertEqual(content.type, .movie)
        XCTAssertEqual(content.recommender, "John Doe")
        XCTAssertNil(content.notes)
        XCTAssertNil(content.externalId)
        XCTAssertNil(content.source)
        XCTAssertNotNil(content.id)
        XCTAssertNotNil(content.creationDate)
        XCTAssertNotNil(content.modificationDate)
    }
    
    func testContentEquality() {
        let content1 = Content(
            title: "Test Title",
            type: .movie,
            recommender: "John Doe"
        )
        
        let content2 = Content(
            title: "Test Title",
            type: .movie,
            recommender: "John Doe"
        )
        
        XCTAssertNotEqual(content1.id, content2.id)
        XCTAssertNotEqual(content1.creationDate, content2.creationDate)
    }
    
    func testContentTypeCases() {
        XCTAssertEqual(ContentType.allCases.count, 5)
        XCTAssertTrue(ContentType.allCases.contains(.movie))
        XCTAssertTrue(ContentType.allCases.contains(.tvShow))
        XCTAssertTrue(ContentType.allCases.contains(.podcast))
        XCTAssertTrue(ContentType.allCases.contains(.book))
        XCTAssertTrue(ContentType.allCases.contains(.audiobook))
    }
    
    func testContentUpdate() {
        let content = Content(
            title: "Original Title",
            type: .movie,
            recommender: "Original Recommender"
        )
        
        let originalModificationDate = content.modificationDate
        
        // Wait a moment to ensure the modification date will be different
        Thread.sleep(forTimeInterval: 0.1)
        
        content.update(
            title: "Updated Title",
            type: .tvShow,
            recommender: "Updated Recommender",
            notes: "Updated Notes",
            externalId: "456",
            source: "Updated Source"
        )
        
        XCTAssertEqual(content.title, "Updated Title")
        XCTAssertEqual(content.type, .tvShow)
        XCTAssertEqual(content.recommender, "Updated Recommender")
        XCTAssertEqual(content.notes, "Updated Notes")
        XCTAssertEqual(content.externalId, "456")
        XCTAssertEqual(content.source, "Updated Source")
        XCTAssertNotEqual(content.modificationDate, originalModificationDate)
    }
} 