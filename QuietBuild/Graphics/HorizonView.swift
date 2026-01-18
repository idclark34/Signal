import SwiftUI

struct HorizonView: View {
    @State private var lightOffset: CGFloat = -0.3
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 1)

                if !reduceMotion {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.white.opacity(0.15), Color.clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 60
                            )
                        )
                        .frame(width: 120, height: 120)
                        .offset(x: geometry.size.width * lightOffset)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 40)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(
                .easeInOut(duration: 7)
                .repeatForever(autoreverses: true)
            ) {
                lightOffset = 0.3
            }
        }
    }
}
