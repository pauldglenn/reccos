import SwiftUI

struct ContentDetailView: View {
    let content: Content
    @EnvironmentObject var viewModel: ContentViewModel
    @State private var showingEditSheet = false
    
    var body: some View {
        List {
            Section(header: Text("Details")) {
                DetailRow(title: "Title", value: content.title)
                    .accessibilityIdentifier("Detail Title")
                DetailRow(title: "Type", value: content.type.rawValue.capitalized)
                    .accessibilityIdentifier("Detail Type")
                DetailRow(title: "Recommended by", value: content.recommender)
                    .accessibilityIdentifier("Detail Recommender")
                DetailRow(title: "Date Recommended", value: content.creationDate.formatted())
                    .accessibilityIdentifier("Detail Creation Date")
                if content.creationDate != content.modificationDate {
                    DetailRow(title: "Last Modified", value: content.modificationDate.formatted())
                        .accessibilityIdentifier("Detail Modification Date")
                }
                if let source = content.source {
                    DetailRow(title: "Source", value: source)
                        .accessibilityIdentifier("Detail Source")
                }
            }
            
            if let notes = content.notes {
                Section(header: Text("Notes")) {
                    Text(notes)
                        .padding(.vertical, 4)
                        .accessibilityIdentifier("Detail Notes")
                }
            }
            
            Section {
                Button(action: {
                    showingEditSheet = true
                }) {
                    Label("Edit Recommendation", systemImage: "pencil")
                        .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 8)
                .buttonStyle(.bordered)
                .accessibilityIdentifier("Edit Recommendation Button")
                .accessibilityLabel("Edit Recommendation")
                .accessibilityAddTraits(.isButton)
                .accessibilityHint("Tap to edit this recommendation")
                .accessibilityElement(children: .combine)
            }
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .listRowBackground(Color.clear)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Edit Section")
            .listRowSeparator(.hidden)
            .listRowSeparatorTint(.clear)
            .listSectionSeparator(.hidden)
            .listSectionSeparatorTint(.clear)
        }
        #if os(macOS)
        .listStyle(.bordered)
        #else
        .listStyle(.insetGrouped)
        #endif
        .navigationTitle(content.title)
        .sheet(isPresented: $showingEditSheet) {
            EditRecommendationView(content: content)
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
                .frame(width: 120, alignment: .leading)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
    }
}

struct EditRecommendationView: View {
    let content: Content
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ContentViewModel
    
    @State private var title: String
    @State private var type: ContentType
    @State private var recommender: String
    @State private var notes: String
    
    init(content: Content) {
        self.content = content
        _title = State(initialValue: content.title)
        _type = State(initialValue: content.type)
        _recommender = State(initialValue: content.recommender)
        _notes = State(initialValue: content.notes ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Content Details")) {
                    TextField("Title", text: $title)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier("Edit Title Field")
                    Picker("Type", selection: $type) {
                        ForEach(ContentType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    .accessibilityIdentifier("Edit Type Picker")
                    TextField("Recommended by", text: $recommender)
                        .textFieldStyle(.roundedBorder)
                        .accessibilityIdentifier("Edit Recommender Field")
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                        .accessibilityIdentifier("Edit Notes Field")
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Edit Recommendation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("Edit Cancel Button")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(title.isEmpty || recommender.isEmpty)
                    .accessibilityIdentifier("Edit Save Button")
                    .accessibilityLabel("Save Changes")
                    .accessibilityAddTraits(.isButton)
                    .accessibilityHint("Tap to save your changes")
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }
    
    private func saveChanges() {
        content.update(
            title: title,
            type: type,
            recommender: recommender,
            notes: notes.isEmpty ? nil : notes
        )
        dismiss()
    }
} 