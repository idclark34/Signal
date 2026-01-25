import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct OnboardingView: View {
    @State private var currentPage = 0
    let onComplete: () -> Void
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "leaf.fill",
            title: "Welcome to Signal",
            description: "A gentle companion that sends you mindful reminders throughout the day to pause, breathe, and reconnect with what matters."
        ),
        OnboardingPage(
            icon: "clock.fill",
            title: "Scheduled Reminders",
            description: "Signal quietly appears during your chosen hours with calming messages. Set your active hours and frequency in Settings."
        ),
        OnboardingPage(
            icon: "waveform.path",
            title: "Calming Visuals",
            description: "Each reminder features a soothing animation—a progress line, horizon, or moving dot—to help you center yourself."
        ),
        OnboardingPage(
            icon: "menubar.rectangle",
            title: "Lives in Your Menu Bar",
            description: "Signal runs quietly in your menu bar. Click the leaf icon anytime to show a reminder or access settings."
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Page content
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.automatic)
            .frame(height: 280)
            
            // Page indicators
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.white : Color.white.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut(duration: 0.2), value: currentPage)
                }
            }
            .padding(.bottom, 24)
            
            // Navigation buttons
            HStack(spacing: 16) {
                if currentPage > 0 {
                    Button("Back") {
                        withAnimation {
                            currentPage -= 1
                        }
                    }
                    .buttonStyle(OnboardingSecondaryButtonStyle())
                }
                
                Spacer()
                
                if currentPage < pages.count - 1 {
                    Button("Next") {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                    .buttonStyle(OnboardingPrimaryButtonStyle())
                } else {
                    Button("Get Started") {
                        onComplete()
                    }
                    .buttonStyle(OnboardingPrimaryButtonStyle())
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .frame(width: 420, height: 420)
        .background(
            LinearGradient(
                colors: [Color(white: 0.12), Color(white: 0.08)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: page.icon)
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.white.opacity(0.9))
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            
            Text(page.title)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 40)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding(.top, 32)
    }
}

struct OnboardingPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.black)
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct OnboardingSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white.opacity(0.7))
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

class OnboardingWindowController: NSObject {
    private var window: NSWindow?
    private let onComplete: () -> Void
    
    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        super.init()
    }
    
    func show() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 420, height: 420),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "Welcome to Signal"
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.backgroundColor = NSColor(white: 0.1, alpha: 1)
        window.isMovableByWindowBackground = true
        
        let onboardingView = OnboardingView { [weak self] in
            self?.close()
        }
        
        window.contentView = NSHostingView(rootView: onboardingView)
        window.center()
        
        self.window = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func close() {
        window?.close()
        window = nil
        onComplete()
    }
}
