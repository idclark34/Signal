import Foundation

struct Message: Identifiable, Codable, Equatable {
    let id: UUID
    let text: String
    let savedAt: Date?

    init(id: UUID = UUID(), text: String, savedAt: Date? = nil) {
        self.id = id
        self.text = text
        self.savedAt = savedAt
    }

    func withSavedDate() -> Message {
        Message(id: id, text: text, savedAt: Date())
    }
}
