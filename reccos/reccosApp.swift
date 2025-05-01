//
//  reccosApp.swift
//  reccos
//
//  Created by Paul Glenn on 4/28/25.
//

import SwiftUI
import SwiftData

@main
struct reccosApp: App {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentListView()
                    .environmentObject(viewModel)
            }
        }
        .modelContainer(for: Content.self)
    }
}


class ContentViewModel: ObservableObject {
    @Published var recommendations: [Content] = []
    @Published var searchText: String = ""
    @Published var selectedType: ContentType?
    @Published var sortOption: SortOption = .date
    @Published var filterOption: FilterOption = .all
    @Published var searchResults: [SearchResult] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let apiService: APIService
    
    init(apiService: APIService = APIService.shared) {
        self.apiService = apiService
    }
    
    enum SortOption {
        case date
        case title
        case recommender
    }
    
    enum FilterOption {
        case all
        case podcasts
        case books
        case audiobooks
        case tvShows
        case movies
    }
    
    func addRecommendation(_ content: Content) {
        recommendations.append(content)
    }
    
    func removeRecommendation(_ content: Content) {
        recommendations.removeAll { $0.id == content.id }
    }
    
    func searchContent(query: String, type: ContentType) async {
        isLoading = true
        errorMessage = nil
        
        do {
            searchResults = try await apiService.searchAll(query: query, type: type)
        } catch {
            errorMessage = "Error searching: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    var filteredAndSortedRecommendations: [Content] {
        var filtered = recommendations
        
        // Apply filter
        switch filterOption {
        case .all:
            break
        case .podcasts:
            filtered = filtered.filter { $0.type == .podcast }
        case .books:
            filtered = filtered.filter { $0.type == .book }
        case .audiobooks:
            filtered = filtered.filter { $0.type == .audiobook }
        case .tvShows:
            filtered = filtered.filter { $0.type == .tvShow }
        case .movies:
            filtered = filtered.filter { $0.type == .movie }
        }
        
        // Apply sort
        switch sortOption {
        case .date:
            return filtered.sorted(by: { $0.creationDate > $1.creationDate })
        case .title:
            return filtered.sorted(by: { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending })
        case .recommender:
            return filtered.sorted(by: { $0.recommender.localizedCaseInsensitiveCompare($1.recommender) == .orderedAscending })
        }
    }
}
