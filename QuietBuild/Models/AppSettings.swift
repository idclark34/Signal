import Foundation

enum GraphicType: String, CaseIterable, Codable {
    case random = "Random"
    case progressLine = "Progress Line"
    case horizon = "Horizon"
    case movingDot = "Moving Dot"
}

enum PopupFrequency: String, CaseIterable {
    case thirtyMinutes = "Every 30 minutes"
    case oneHour = "Every hour"
    case twoHours = "Every 2 hours"
    case fourHours = "Every 4 hours"
    case onceDaily = "Once a day"

    var minutes: Int {
        switch self {
        case .thirtyMinutes: return 30
        case .oneHour: return 60
        case .twoHours: return 120
        case .fourHours: return 240
        case .onceDaily: return 1440
        }
    }
}

class AppSettings: ObservableObject {
    static let shared = AppSettings()

    @Published var dailyPopupEnabled: Bool {
        didSet { UserDefaults.standard.set(dailyPopupEnabled, forKey: "dailyPopupEnabled") }
    }

    @Published var animationsEnabled: Bool {
        didSet { UserDefaults.standard.set(animationsEnabled, forKey: "animationsEnabled") }
    }

    @Published var graphicType: GraphicType {
        didSet { UserDefaults.standard.set(graphicType.rawValue, forKey: "graphicType") }
    }

    @Published var frequency: PopupFrequency {
        didSet { UserDefaults.standard.set(frequency.rawValue, forKey: "frequency") }
    }

    @Published var windowStartHour: Int {
        didSet { UserDefaults.standard.set(windowStartHour, forKey: "windowStartHour") }
    }

    @Published var windowEndHour: Int {
        didSet { UserDefaults.standard.set(windowEndHour, forKey: "windowEndHour") }
    }

    private init() {
        let defaults = UserDefaults.standard

        if defaults.object(forKey: "dailyPopupEnabled") == nil {
            defaults.set(true, forKey: "dailyPopupEnabled")
        }
        if defaults.object(forKey: "animationsEnabled") == nil {
            defaults.set(true, forKey: "animationsEnabled")
        }
        if defaults.object(forKey: "graphicType") == nil {
            defaults.set(GraphicType.random.rawValue, forKey: "graphicType")
        }
        if defaults.object(forKey: "frequency") == nil {
            defaults.set(PopupFrequency.oneHour.rawValue, forKey: "frequency")
        }
        if defaults.object(forKey: "windowStartHour") == nil {
            defaults.set(19, forKey: "windowStartHour") // 7 PM
        }
        if defaults.object(forKey: "windowEndHour") == nil {
            defaults.set(22, forKey: "windowEndHour") // 10 PM
        }

        self.dailyPopupEnabled = defaults.bool(forKey: "dailyPopupEnabled")
        self.animationsEnabled = defaults.bool(forKey: "animationsEnabled")
        self.graphicType = GraphicType(rawValue: defaults.string(forKey: "graphicType") ?? "") ?? .random
        self.frequency = PopupFrequency(rawValue: defaults.string(forKey: "frequency") ?? "") ?? .oneHour
        self.windowStartHour = defaults.integer(forKey: "windowStartHour")
        self.windowEndHour = defaults.integer(forKey: "windowEndHour")
    }
}
