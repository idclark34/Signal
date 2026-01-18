import SwiftUI
import AppKit

struct SavedThoughtsView: View {
    @ObservedObject var store: SavedMessagesStore

    var body: some View {
        VStack(spacing: 0) {
            if store.messages.isEmpty {
                emptyState
            } else {
                messageList
            }
        }
        .frame(minWidth: 320, minHeight: 300)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("No saved thoughts yet")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Save a message from the popup to see it here.")
                .font(.subheadline)
                .foregroundColor(.secondary.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var messageList: some View {
        List {
            ForEach(store.messages) { message in
                MessageRow(message: message, onCopy: {
                    copyToClipboard(message.text)
                }, onDelete: {
                    store.delete(message)
                })
            }
        }
        .listStyle(.inset)
    }

    private func copyToClipboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }
}

struct MessageRow: View {
    let message: Message
    let onCopy: () -> Void
    let onDelete: () -> Void

    @State private var isHovering = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(message.text)
                    .font(.system(size: 14))

                if let savedAt = message.savedAt {
                    Text(savedAt, style: .date)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            if isHovering {
                HStack(spacing: 8) {
                    Button(action: onCopy) {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 12))
                    }
                    .buttonStyle(.plain)
                    .help("Copy to clipboard")

                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 12))
                            .foregroundColor(.red.opacity(0.7))
                    }
                    .buttonStyle(.plain)
                    .help("Delete")
                }
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onHover { hovering in
            isHovering = hovering
        }
    }
}
