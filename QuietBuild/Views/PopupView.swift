import SwiftUI
import AppKit

enum ExitAnimation: CaseIterable {
    case flipUp
    case shrinkInward
    case slideDown
}

class PopupAnimationState: ObservableObject {
    @Published var isVisible = false
    @Published var isDismissing = false
    let exitAnimation: ExitAnimation = ExitAnimation.allCases.randomElement()!
}

struct TextExitModifier: ViewModifier {
    let exitAnimation: ExitAnimation
    let isDismissing: Bool

    func body(content: Content) -> some View {
        switch exitAnimation {
        case .flipUp:
            content
                .rotation3DEffect(
                    .degrees(isDismissing ? -90 : 0),
                    axis: (x: 1, y: 0, z: 0),
                    anchor: .top,
                    perspective: 0.3
                )
        case .shrinkInward:
            content
                .scaleEffect(isDismissing ? 0.3 : 1)
        case .slideDown:
            content
                .offset(y: isDismissing ? 40 : 0)
                .blur(radius: isDismissing ? 4 : 0)
        }
    }
}

struct PopupView: View {
    let message: Message
    @ObservedObject var animationState: PopupAnimationState

    private let settings = AppSettings.shared

    var body: some View {
        VStack(spacing: 24) {
            graphicView
                .padding(.horizontal, 40)
                .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 2)
                .opacity(animationState.isVisible ? (animationState.isDismissing ? 0 : 1) : 0)

            Text(message.text)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 24)
                .shadow(color: .black, radius: 1, x: 0, y: 1)
                .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 2)
                .shadow(color: .black.opacity(0.5), radius: 12, x: 0, y: 4)
                .modifier(TextExitModifier(
                    exitAnimation: animationState.exitAnimation,
                    isDismissing: animationState.isDismissing
                ))
                .opacity(animationState.isVisible ? (animationState.isDismissing ? 0 : 1) : 0)

        }
        .frame(width: Constants.popupWidth, height: Constants.popupHeight)
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                animationState.isVisible = true
            }
        }
    }

    @ViewBuilder
    private var graphicView: some View {
        if settings.animationsEnabled {
            switch resolvedGraphicType {
            case .progressLine:
                ProgressLineView()
            case .horizon:
                HorizonView()
            case .movingDot:
                MovingDotView()
            case .random:
                ProgressLineView()
            }
        } else {
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(height: 2)
                .padding(.horizontal, 40)
        }
    }

    private var resolvedGraphicType: GraphicType {
        if settings.graphicType == .random {
            return [GraphicType.progressLine, .horizon, .movingDot].randomElement()!
        }
        return settings.graphicType
    }
}

class PopupWindowController: NSObject {
    private var window: NSPanel?
    private var dismissTimer: Timer?
    private let message: Message
    private let onDismiss: () -> Void
    private let animationState = PopupAnimationState()
    private var isClosing = false

    init(message: Message, onDismiss: @escaping () -> Void) {
        self.message = message
        self.onDismiss = onDismiss
        super.init()
    }

    func showPopup() {
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: Constants.popupWidth, height: Constants.popupHeight),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        panel.isFloatingPanel = true
        panel.level = .floating
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = false
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        let popupView = PopupView(message: message, animationState: animationState)
        let hostingView = NSHostingView(rootView: popupView)
        hostingView.frame = panel.contentView!.bounds

        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick))
        hostingView.addGestureRecognizer(clickGesture)

        panel.contentView = hostingView
        panel.center()

        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.keyCode == 53 {
                self?.close()
                return nil
            }
            return event
        }

        self.window = panel
        panel.orderFrontRegardless()

        dismissTimer = Timer.scheduledTimer(withTimeInterval: Constants.autoDismissDelay, repeats: false) { [weak self] _ in
            self?.close()
        }
    }

    @objc private func handleClick(_ gesture: NSClickGestureRecognizer) {
        close()
    }

    func close() {
        guard !isClosing else { return }
        isClosing = true

        dismissTimer?.invalidate()
        dismissTimer = nil

        withAnimation(.easeIn(duration: 0.3)) {
            animationState.isDismissing = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            self?.window?.orderOut(nil)
            self?.window = nil
            self?.onDismiss()
        }
    }
}
