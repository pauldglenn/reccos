import XCTest
@testable import reccos

final class ContentViewModelTests: XCTestCase {
    var viewModel: ContentViewModel!
    var mockAPIService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService.mockShared
        viewModel = ContentViewModel(apiService: mockAPIService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testAddRecommendation() {
        let content = Content(
            title: "Test Title",
            type: .movie,
            recommender: "John Doe",
            notes: "Great movie!",
            externalId: "123",
            source: "IMDB"
        )
        
        viewModel.addRecommendation(content)
        
        XCTAssertEqual(viewModel.recommendations.count, 1)
        XCTAssertEqual(viewModel.recommendations.first?.title, "Test Title")
        XCTAssertEqual(viewModel.recommendations.first?.type, .movie)
        XCTAssertEqual(viewModel.recommendations.first?.recommender, "John Doe")
        XCTAssertEqual(viewModel.recommendations.first?.notes, "Great movie!")
        XCTAssertEqual(viewModel.recommendations.first?.externalId, "123")
        XCTAssertEqual(viewModel.recommendations.first?.source, "IMDB")
    }
    
    func testRemoveRecommendation() {
        let content = Content(
            title: "Test Title",
            type: .movie,
            recommender: "John Doe"
        )
        
        viewModel.addRecommendation(content)
        viewModel.removeRecommendation(content)
        
        XCTAssertTrue(viewModel.recommendations.isEmpty)
    }
    
    func testFiltering() {
        let movie = Content(title: "Movie", type: .movie, recommender: "John")
        let podcast = Content(title: "Podcast", type: .podcast, recommender: "Jane")
        let tvShow = Content(title: "TV Show", type: .tvShow, recommender: "Bob")
        let book = Content(title: "Book", type: .book, recommender: "Alice")
        
        viewModel.addRecommendation(movie)
        viewModel.addRecommendation(podcast)
        viewModel.addRecommendation(tvShow)
        viewModel.addRecommendation(book)
        
        viewModel.filterOption = .movies
        XCTAssertEqual(viewModel.filteredAndSortedRecommendations.count, 1)
        XCTAssertEqual(viewModel.filteredAndSortedRecommendations.first?.type, .movie)
        
        viewModel.filterOption = .podcasts
        XCTAssertEqual(viewModel.filteredAndSortedRecommendations.count, 1)
        XCTAssertEqual(viewModel.filteredAndSortedRecommendations.first?.type, .podcast)
        
        viewModel.filterOption = .tvShows
        XCTAssertEqual(viewModel.filteredAndSortedRecommendations.count, 1)
        XCTAssertEqual(viewModel.filteredAndSortedRecommendations.first?.type, .tvShow)
        
        viewModel.filterOption = .books
        XCTAssertEqual(viewModel.filteredAndSortedRecommendations.count, 1)
        XCTAssertEqual(viewModel.filteredAndSortedRecommendations.first?.type, .book)
        
        viewModel.filterOption = .all
        XCTAssertEqual(viewModel.filteredAndSortedRecommendations.count, 4)
    }
    
    func testSorting() {
        let now = Date()
        let oneHourAgo = now.addingTimeInterval(-3600)
        let twoHoursAgo = now.addingTimeInterval(-7200)
        
        // Create content with explicit creation dates
        let content1 = Content(
            title: "B",
            type: .movie,
            recommender: "John",
            creationDate: oneHourAgo
        )
        
        let content2 = Content(
            title: "A",
            type: .movie,
            recommender: "Jane",
            creationDate: twoHoursAgo
        )
        
        let content3 = Content(
            title: "C",
            type: .movie,
            recommender: "Alice",
            creationDate: now
        )
        
        // Add content in any order since we're controlling the dates
        viewModel.addRecommendation(content1)
        viewModel.addRecommendation(content2)
        viewModel.addRecommendation(content3)
        
        // Test title sorting
        viewModel.sortOption = .title
        let titleSorted = viewModel.filteredAndSortedRecommendations
        XCTAssertEqual(titleSorted.first?.title, "A")
        XCTAssertEqual(titleSorted.last?.title, "C")
        
        // Test recommender sorting
        viewModel.sortOption = .recommender
        let recommenderSorted = viewModel.filteredAndSortedRecommendations
        XCTAssertEqual(recommenderSorted.first?.recommender, "Alice")
        XCTAssertEqual(recommenderSorted.last?.recommender, "John")
        
        // Test date sorting
        viewModel.sortOption = .date
        let dateSorted = viewModel.filteredAndSortedRecommendations
        XCTAssertEqual(dateSorted.first?.title, "C")
        XCTAssertEqual(dateSorted.last?.title, "A")
    }
    
    func testSearchContent() async {
        let expectation = XCTestExpectation(description: "Search content")
        
        Task {
            await viewModel.searchContent(query: "inception", type: .movie)
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertEqual(viewModel.searchResults.count, 1)
            XCTAssertEqual(viewModel.searchResults.first?.title, "Inception")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func testSearchContentError() async {
        let expectation = XCTestExpectation(description: "Search content with error")
        
        Task {
            await viewModel.searchContent(query: "", type: .movie)
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertTrue(viewModel.searchResults.isEmpty)
            XCTAssertNotNil(viewModel.errorMessage)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func testSearchContentLoadingState() async {
        let expectation = XCTestExpectation(description: "Search content loading state")
        
        Task {
            XCTAssertFalse(viewModel.isLoading)
            await viewModel.searchContent(query: "inception", type: .movie)
            XCTAssertFalse(viewModel.isLoading)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
} 