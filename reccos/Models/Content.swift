import Foundation
import SwiftData

enum ContentType: String, Codable, CaseIterable {
    case podcast
    case book
    case audiobook
    case tvShow
    case movie
}

@Model
final class Content {
    var id: UUID
    var title: String
    var type: ContentType
    var recommender: String
    let creationDate: Date
    var modificationDate: Date
    var notes: String?
    var externalId: String? // For storing IDs from Spotify, Amazon, or IMDB
    var source: String? // To track which service the content was found on
    
    init(id: UUID = UUID(), 
         title: String, 
         type: ContentType, 
         recommender: String, 
         notes: String? = nil, 
         externalId: String? = nil, 
         source: String? = nil,
         creationDate: Date? = nil) {
        self.id = id
        self.title = title
        self.type = type
        self.recommender = recommender
        self.creationDate = creationDate ?? Date()
        self.modificationDate = Date()
        self.notes = notes
        self.externalId = externalId
        self.source = source
    }
    
    func update(title: String? = nil, type: ContentType? = nil, recommender: String? = nil, notes: String? = nil, externalId: String? = nil, source: String? = nil) {
        if let title = title { self.title = title }
        if let type = type { self.type = type }
        if let recommender = recommender { self.recommender = recommender }
        if let notes = notes { self.notes = notes }
        if let externalId = externalId { self.externalId = externalId }
        if let source = source { self.source = source }
        self.modificationDate = Date()
    }
} 