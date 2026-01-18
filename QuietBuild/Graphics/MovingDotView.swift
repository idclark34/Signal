import SwiftUI

struct MovingDotView: View {
    @State private var dotPosition: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 1)

                Circle()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 8, height: 8)
                    .offset(x: (geometry.size.width - 8) * dotPosition)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .frame(height: 40)
        .onAppear {
            guard !reduceMotion else {
                dotPosition = 0.5
                return
            }
            withAnimation(
                .easeInOut(duration: 3)
                .repeatForever(autoreverses: true)
            ) {
                dotPosition = 1
            }
        }
    }
}
