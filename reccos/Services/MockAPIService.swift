import Foundation

class MockAPIService: APIService {
    static let mockShared = MockAPIService()
    
    private override init() {
        super.init()
    }
    
    // Mock data
    private let mockSpotifyResults = [
        SearchResult(id: "spotify1", title: "The Daily", type: .podcast, source: "Spotify", externalId: "spotify:show:123"),
        SearchResult(id: "spotify2", title: "Serial", type: .podcast, source: "Spotify", externalId: "spotify:show:456")
    ]
    
    private let mockAmazonResults = [
        SearchResult(id: "amazon1", title: "The Great Gatsby", type: .book, source: "Amazon", externalId: "B0012345678"),
        SearchResult(id: "amazon2", title: "Atomic Habits", type: .book, source: "Amazon", externalId: "B0098765432")
    ]
    
    private let mockIMDBResults = [
        SearchResult(id: "imdb1", title: "Inception", type: .movie, source: "IMDB", externalId: "tt1375666"),
        SearchResult(id: "imdb2", title: "Breaking Bad", type: .tvShow, source: "IMDB", externalId: "tt0903747")
    ]
    
    override func searchSpotify(query: String, type: ContentType) async throws -> [SearchResult] {
        guard type == .podcast else { return [] }
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return mockSpotifyResults.filter { $0.title.lowercased().contains(query.lowercased()) }
    }
    
    override func searchAmazon(query: String, type: ContentType) async throws -> [SearchResult] {
        guard type == .book || type == .audiobook else { return [] }
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return mockAmazonResults.filter { $0.title.lowercased().contains(query.lowercased()) }
    }
    
    override func searchIMDB(query: String, type: ContentType) async throws -> [SearchResult] {
        guard type == .movie || type == .tvShow else { return [] }
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return mockIMDBResults.filter { $0.title.lowercased().contains(query.lowercased()) }
    }
    
    override func searchAll(query: String, type: ContentType) async throws -> [SearchResult] {
        // Throw error for empty query
        if query.isEmpty {
            throw NSError(domain: "MockAPIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Query cannot be empty"])
        }
        
        var results: [SearchResult] = []
        
        if type == .podcast {
            results += try await searchSpotify(query: query, type: type)
        }
        
        if type == .book || type == .audiobook {
            results += try await searchAmazon(query: query, type: type)
        }
        
        if type == .movie || type == .tvShow {
            results += try await searchIMDB(query: query, type: type)
        }
        
        return results
    }
} 