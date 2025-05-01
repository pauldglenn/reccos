import XCTest
@testable import reccos

final class APIServiceTests: XCTestCase {
    var apiService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        apiService = MockAPIService.mockShared
    }
    
    override func tearDown() {
        apiService = nil
        super.tearDown()
    }
    
    func testSearchSpotify() async throws {
        // Test podcast search
        let podcastResults = try await apiService.searchSpotify(query: "daily", type: .podcast)
        XCTAssertEqual(podcastResults.count, 1)
        XCTAssertEqual(podcastResults.first?.title, "The Daily")
        XCTAssertEqual(podcastResults.first?.type, .podcast)
        XCTAssertEqual(podcastResults.first?.source, "Spotify")
        
        // Test non-podcast search returns empty
        let movieResults = try await apiService.searchSpotify(query: "inception", type: .movie)
        XCTAssertTrue(movieResults.isEmpty)
    }
    
    func testSearchAmazon() async throws {
        // Test book search
        let bookResults = try await apiService.searchAmazon(query: "gatsby", type: .book)
        XCTAssertEqual(bookResults.count, 1)
        XCTAssertEqual(bookResults.first?.title, "The Great Gatsby")
        XCTAssertEqual(bookResults.first?.type, .book)
        XCTAssertEqual(bookResults.first?.source, "Amazon")
        
        // Test non-book search returns empty
        let movieResults = try await apiService.searchAmazon(query: "inception", type: .movie)
        XCTAssertTrue(movieResults.isEmpty)
    }
    
    func testSearchIMDB() async throws {
        // Test movie search
        let movieResults = try await apiService.searchIMDB(query: "inception", type: .movie)
        XCTAssertEqual(movieResults.count, 1)
        XCTAssertEqual(movieResults.first?.title, "Inception")
        XCTAssertEqual(movieResults.first?.type, .movie)
        XCTAssertEqual(movieResults.first?.source, "IMDB")
        
        // Test TV show search
        let tvResults = try await apiService.searchIMDB(query: "breaking", type: .tvShow)
        XCTAssertEqual(tvResults.count, 1)
        XCTAssertEqual(tvResults.first?.title, "Breaking Bad")
        XCTAssertEqual(tvResults.first?.type, .tvShow)
        
        // Test non-movie/TV search returns empty
        let bookResults = try await apiService.searchIMDB(query: "gatsby", type: .book)
        XCTAssertTrue(bookResults.isEmpty)
    }
    
    func testSearchAll() async throws {
        // Test movie search
        let movieResults = try await apiService.searchAll(query: "inception", type: .movie)
        XCTAssertEqual(movieResults.count, 1)
        XCTAssertEqual(movieResults.first?.title, "Inception")
        
        // Test podcast search
        let podcastResults = try await apiService.searchAll(query: "serial", type: .podcast)
        XCTAssertEqual(podcastResults.count, 1)
        XCTAssertEqual(podcastResults.first?.title, "Serial")
        
        // Test book search
        let bookResults = try await apiService.searchAll(query: "atomic", type: .book)
        XCTAssertEqual(bookResults.count, 1)
        XCTAssertEqual(bookResults.first?.title, "Atomic Habits")
    }
    
    func testSearchResultInitialization() {
        let result = SearchResult(
            id: "123",
            title: "Test Title",
            type: .movie,
            source: "IMDB",
            externalId: "456"
        )
        
        XCTAssertEqual(result.id, "123")
        XCTAssertEqual(result.title, "Test Title")
        XCTAssertEqual(result.type, .movie)
        XCTAssertEqual(result.source, "IMDB")
        XCTAssertEqual(result.externalId, "456")
    }
    
    func testSearchPerformance() async throws {
        measure {
            Task {
                _ = try? await apiService.searchAll(query: "test", type: .movie)
            }
        }
    }
} 