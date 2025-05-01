import SwiftUI

struct ContentListView: View {
    @EnvironmentObject var viewModel: ContentViewModel
    @State private var showingAddSheet = false
    @State private var showingFilterSheet = false
    
    var body: some View {
        List {
            ForEach(viewModel.filteredAndSortedRecommendations) { content in
                NavigationLink(destination: ContentDetailView(content: content)) {
                    ContentRowView(content: content)
                        .padding(.vertical, 8)
                }
                .accessibilityIdentifier("Content Row \(content.title)")
            }
            .onDelete { indexSet in
                for index in indexSet {
                    viewModel.removeRecommendation(viewModel.filteredAndSortedRecommendations[index])
                }
            }
        }
        #if os(macOS)
        .listStyle(.bordered)
        #else
        .listStyle(.insetGrouped)
        #endif
        .navigationTitle("Recommendations")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                        .font(.title3)
                }
                .accessibilityIdentifier("Add Button")
            }
            
            ToolbarItem(placement: .automatic) {
                Button(action: { showingFilterSheet = true }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title3)
                }
                .accessibilityIdentifier("Filter Button")
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddRecommendationView()
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterSortView()
        }
    }
}

struct FilterSortView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ContentViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Filter By")) {
                Picker("Content Type", selection: $viewModel.filterOption) {
                    Text("All").tag(ContentViewModel.FilterOption.all)
                    Text("Podcasts").tag(ContentViewModel.FilterOption.podcasts)
                    Text("Books").tag(ContentViewModel.FilterOption.books)
                    Text("Audiobooks").tag(ContentViewModel.FilterOption.audiobooks)
                    Text("TV Shows").tag(ContentViewModel.FilterOption.tvShows)
                    Text("Movies").tag(ContentViewModel.FilterOption.movies)
                }
                .pickerStyle(.menu)
                .accessibilityIdentifier("Filter Type Picker")
            }
            
            Section(header: Text("Sort By")) {
                Picker("Sort Order", selection: $viewModel.sortOption) {
                    Text("Date").tag(ContentViewModel.SortOption.date)
                    Text("Title").tag(ContentViewModel.SortOption.title)
                    Text("Recommender").tag(ContentViewModel.SortOption.recommender)
                }
                .pickerStyle(.menu)
                .accessibilityIdentifier("Sort Order Picker")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Filter & Sort")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { dismiss() }
                    .accessibilityIdentifier("Filter Done Button")
            }
        }
    }
}

struct ContentRowView: View {
    let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(content.title)
                .font(.headline)
                .lineLimit(2)
                .accessibilityIdentifier("Row Title")
            
            HStack {
                Text(content.type.rawValue.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .accessibilityIdentifier("Row Type")
                
                Spacer()
                
                Text(content.recommender)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .accessibilityIdentifier("Row Recommender")
            }
            
            if let notes = content.notes {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .accessibilityIdentifier("Row Notes")
            }
        }
        .padding(.vertical, 4)
    }
} 