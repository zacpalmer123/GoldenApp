import SwiftUI
import AVFoundation
struct SpeedToggle: View {
    @Binding var selectedSpeed: RearCameraType
    var availableSpeeds: [RearCameraType]
    var onSelect: (RearCameraType) -> Void

    private let buttonWidth: CGFloat = 30
    private let spacing: CGFloat = 10

    var body: some View {
        ZStack {
            backgroundFrame

            ZStack(alignment: .leading) {
                selectionCircle
                speedButtons
            }
            .frame(height: buttonWidth)
        }
        .frame(height: 40)
    }

    private var backgroundFrame: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.ultraThinMaterial)
            .frame(width: totalWidth, height: 40)
    }

    private var selectionCircle: some View {
        Circle()
            .fill(Color.gray)
            .frame(width: buttonWidth, height: buttonWidth)
            .offset(x: offsetForSelected())
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedSpeed)
    }

    private var speedButtons: some View {
        HStack(spacing: spacing) {
            ForEach(availableSpeeds, id: \.self) { speed in
                speedButton(for: speed)
            }
        }
    }

    private func speedButton(for speed: RearCameraType) -> some View {
        Button(action: {
            withAnimation {
                selectedSpeed = speed
                onSelect(speed)
            }
        }) {
            Text(speed.displayLabel)
                .foregroundColor(selectedSpeed == speed ? .yellow : .gray)
                .fontWeight(.medium)
                .frame(width: buttonWidth, height: buttonWidth)
        }
        .buttonStyle(.plain)
    }

    private func offsetForSelected() -> CGFloat {
        guard let index = availableSpeeds.firstIndex(of: selectedSpeed) else { return 0 }
        return CGFloat(index) * (buttonWidth + spacing)
    }

    private var totalWidth: CGFloat {
        CGFloat(availableSpeeds.count) * buttonWidth + CGFloat(availableSpeeds.count - 1) * spacing + 10
    }
}

