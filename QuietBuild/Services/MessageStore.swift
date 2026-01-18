import Foundation

class MessageStore {
    private let recentMessagesKey = "recentMessageIds"
    private let maxRecentCount = 7

    func getNextMessage() -> Message {
        var recentIds = getRecentMessageIds()
        let availableMessages = Constants.messages.enumerated().filter { index, _ in
            !recentIds.contains(index)
        }

        let selectedIndex: Int
        if availableMessages.isEmpty {
            recentIds.removeAll()
            selectedIndex = Int.random(in: 0..<Constants.messages.count)
        } else {
            selectedIndex = availableMessages.randomElement()!.offset
        }

        recentIds.append(selectedIndex)
        if recentIds.count > maxRecentCount {
            recentIds.removeFirst()
        }
        saveRecentMessageIds(recentIds)

        return Message(text: Constants.messages[selectedIndex])
    }

    private func getRecentMessageIds() -> [Int] {
        UserDefaults.standard.array(forKey: recentMessagesKey) as? [Int] ?? []
    }

    private func saveRecentMessageIds(_ ids: [Int]) {
        UserDefaults.standard.set(ids, forKey: recentMessagesKey)
    }
}
