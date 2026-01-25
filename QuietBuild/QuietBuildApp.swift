import SwiftUI
import AppKit

@main
struct QuietBuildApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popupWindowController: PopupWindowController?
    private var settingsWindow: NSWindow?
    private var onboardingWindowController: OnboardingWindowController?
    private let messageStore = MessageStore()
    private let popupScheduler = PopupScheduler()
    private let settings = AppSettings.shared

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenubar()
        popupScheduler.onTrigger = { [weak self] in
            self?.showPopup()
        }
        
        if !settings.hasCompletedOnboarding {
            showOnboarding()
        } else {
            popupScheduler.start()
        }
    }
    
    private func showOnboarding() {
        onboardingWindowController = OnboardingWindowController { [weak self] in
            self?.settings.hasCompletedOnboarding = true
            self?.onboardingWindowController = nil
            self?.popupScheduler.start()
        }
        onboardingWindowController?.show()
    }

    private func setupMenubar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "leaf.fill", accessibilityDescription: "Signal")
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Show Reminder", action: #selector(showPopup), keyEquivalent: "r"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem(title: "Welcome Guide", action: #selector(showWelcomeGuide), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.menu = menu
    }
    
    @objc func showWelcomeGuide() {
        if onboardingWindowController != nil {
            return
        }
        onboardingWindowController = OnboardingWindowController { [weak self] in
            self?.onboardingWindowController = nil
        }
        onboardingWindowController?.show()
    }

    @objc func showPopup() {
        if popupWindowController != nil {
            popupWindowController?.close()
        }

        let message = messageStore.getNextMessage()
        popupWindowController = PopupWindowController(
            message: message,
            onDismiss: { [weak self] in
                self?.popupWindowController = nil
            }
        )
        popupWindowController?.showPopup()
        popupScheduler.markShown()
    }

    @objc func openSettings() {
        if settingsWindow == nil || !settingsWindow!.isVisible {
            settingsWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 380, height: 280),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            settingsWindow?.title = "Signal Settings"
            settingsWindow?.contentView = NSHostingView(rootView: SettingsView())
            settingsWindow?.center()
            settingsWindow?.isReleasedWhenClosed = false
        }
        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
