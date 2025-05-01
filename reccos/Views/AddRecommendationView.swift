import SwiftUI

struct AddRecommendationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ContentViewModel
    
    @State private var title = ""
    @State private var selectedType: ContentType = .movie
    @State private var recommender = ""
    @State private var notes = ""
    @State private var searchText = ""
    @State private var selectedResult: SearchResult?
    @FocusState private var isNotesFieldFocused: Bool
    @FocusState private var isRecommenderFieldFocused: Bool
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            formContent
        }
        #else
        formContent
        #endif
    }
    
    private var formContent: some View {
        Form {
            Section(header: Text("Search Content")) {
                TextField("Search on Spotify, Amazon, or IMDB", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .accessibilityIdentifier("Search Field")
                
                Picker("Content Type", selection: $selectedType) {
                    ForEach(ContentType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized)
                            .tag(type)
                            .accessibilityIdentifier("Content Type \(type.rawValue)")
                    }
                }
                #if os(iOS)
                .pickerStyle(.navigationLink)
                #else
                .pickerStyle(.menu)
                #endif
                .accessibilityIdentifier("Content Type Picker")
                .accessibilityLabel("Content Type")
            }
            
            Button("Search") {
                Task {
                    await viewModel.searchContent(query: searchText, type: selectedType)
                }
            }
            .disabled(searchText.isEmpty)
            .accessibilityIdentifier(searchText.isEmpty ? "Search Button Disabled" : "Search Button")
            .accessibilityLabel("Search")
            .accessibilityAddTraits(.isButton)
            .accessibilityHint("Tap to search for content")
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .listRowBackground(Color.clear)
            
            if viewModel.isLoading {
                Section {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .accessibilityIdentifier("Loading Indicator")
                }
            }
            
            if let error = viewModel.errorMessage {
                Section {
                    Text(error)
                        .foregroundColor(.red)
                        .accessibilityIdentifier("Error Message")
                }
            }
            
            if !viewModel.searchResults.isEmpty {
                Section(header: Text("Search Results")) {
                    ForEach(viewModel.searchResults) { result in
                        Button(action: { selectResult(result) }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(result.title)
                                        .font(.headline)
                                    Text(result.source)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if selectedResult?.id == result.id {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                        .accessibilityIdentifier("Search Result \(result.title)")
                    }
                }
            }
            
            Section(header: Text("Recommendation Details")) {
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .accessibilityIdentifier("Title Field")
                TextField("Recommended by", text: $recommender)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .accessibilityIdentifier("Recommender Field")
                    .focused($isRecommenderFieldFocused)
                TextField("Notes (optional)", text: $notes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .accessibilityIdentifier("Notes Field")
                    .focused($isNotesFieldFocused)
                    .onTapGesture {
                        isNotesFieldFocused = true
                    }
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Add Recommendation")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .accessibilityIdentifier("Cancel Button")
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveRecommendation()
                }
                .disabled(title.isEmpty || recommender.isEmpty)
                .accessibilityIdentifier("Save Button")
            }
        }
        #if os(iOS)
        .scrollDismissesKeyboard(.immediately)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        #endif
    }
    
    private func selectResult(_ result: SearchResult) {
        selectedResult = result
        title = result.title
    }
    
    private func saveRecommendation() {
        let newContent = Content(
            title: title,
            type: selectedType,
            recommender: recommender,
            notes: notes.isEmpty ? nil : notes,
            externalId: selectedResult?.externalId,
            source: selectedResult?.source
        )
        
        viewModel.addRecommendation(newContent)
        dismiss()
    }
} 