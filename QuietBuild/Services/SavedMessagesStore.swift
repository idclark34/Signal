import Foundation

class SavedMessagesStore: ObservableObject {
    private let storageKey = "savedMessages"

    @Published var messages: [Message] = []

    init() {
        load()
    }

    func save(_ message: Message) {
        let savedMessage = message.withSavedDate()
        if !messages.contains(where: { $0.text == savedMessage.text }) {
            messages.insert(savedMessage, at: 0)
            persist()
        }
    }

    func delete(_ message: Message) {
        messages.removeAll { $0.id == message.id }
        persist()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Message].self, from: data) else {
            return
        }
        messages = decoded
    }

    private func persist() {
        guard let encoded = try? JSONEncoder().encode(messages) else { return }
        UserDefaults.standard.set(encoded, forKey: storageKey)
    }
}
