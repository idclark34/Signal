import SwiftUI

struct ProgressLineView: View {
    @State private var progress: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background line
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 2)

                // Progress line
                Rectangle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: geometry.size.width * progress, height: 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .frame(height: 40)
        .onAppear {
            if reduceMotion {
                progress = 1
            } else {
                withAnimation(.easeInOut(duration: 1.8)) {
                    progress = 1
                }
            }
        }
    }
}
