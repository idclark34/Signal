import Foundation

class PopupScheduler {
    private var timer: Timer?
    private let settings = AppSettings.shared
    private let lastShownKey = "lastPopupDate"

    var onTrigger: (() -> Void)?

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.checkAndTrigger()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func markShown() {
        UserDefaults.standard.set(Date(), forKey: lastShownKey)
    }

    private func checkAndTrigger() {
        guard settings.dailyPopupEnabled else { return }
        guard isWithinTimeWindow() else { return }
        guard hasEnoughTimePassed() else { return }

        DispatchQueue.main.async { [weak self] in
            self?.onTrigger?()
        }
    }

    private func hasEnoughTimePassed() -> Bool {
        guard let lastShown = UserDefaults.standard.object(forKey: lastShownKey) as? Date else {
            return true
        }
        let minutesSinceLastShown = Date().timeIntervalSince(lastShown) / 60
        return minutesSinceLastShown >= Double(settings.frequency.minutes)
    }

    private func isWithinTimeWindow() -> Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= settings.windowStartHour && hour < settings.windowEndHour
    }
}
