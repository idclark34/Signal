import SwiftUI

struct SettingsView: View {
    @ObservedObject private var settings = AppSettings.shared

    var body: some View {
        Form {
            Section {
                Toggle("Enable reminders", isOn: $settings.dailyPopupEnabled)

                Picker("Frequency", selection: $settings.frequency) {
                    ForEach(PopupFrequency.allCases, id: \.self) { freq in
                        Text(freq.rawValue).tag(freq)
                    }
                }

                HStack {
                    Text("Active hours")
                    Spacer()
                    Picker("Start", selection: $settings.windowStartHour) {
                        ForEach(0..<24, id: \.self) { hour in
                            Text(formatHour(hour)).tag(hour)
                        }
                    }
                    .labelsHidden()
                    .frame(width: 80)

                    Text("to")

                    Picker("End", selection: $settings.windowEndHour) {
                        ForEach(0..<24, id: \.self) { hour in
                            Text(formatHour(hour)).tag(hour)
                        }
                    }
                    .labelsHidden()
                    .frame(width: 80)
                }
            } header: {
                Text("Schedule")
            }

            Section {
                Toggle("Enable animations", isOn: $settings.animationsEnabled)

                Picker("Graphic style", selection: $settings.graphicType) {
                    ForEach(GraphicType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            } header: {
                Text("Appearance")
            }
        }
        .formStyle(.grouped)
        .frame(width: 380, height: 280)
    }

    private func formatHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        let date = Calendar.current.date(from: DateComponents(hour: hour))!
        return formatter.string(from: date)
    }
}
