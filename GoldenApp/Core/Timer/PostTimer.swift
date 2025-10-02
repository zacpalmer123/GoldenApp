//
//  PostTimer.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/19/25.
//

import SwiftUI
import Combine

struct PostTimer: View {
    @State private var timeRemaining: TimeInterval = 0
    @State private var displayedTime: String = ""
    var fontSize: CGFloat = 45
    let timer = Timer.publish(every: 1, on: RunLoop.main, in: RunLoop.Mode.common).autoconnect()

    var body: some View {
        VStack(spacing: 20) {
            Text(displayedTime)
                
                .font(.system(size: fontSize, weight: .bold, design: .rounded).monospacedDigit())
                .transition(.scale(scale: 0.8).combined(with: .opacity))
                .id(displayedTime) // This causes the view to refresh when the text changes
                .animation(.easeInOut(duration: 0.3), value: displayedTime)
        }
        .onAppear {
            updateTimeRemaining()
        }
        .onReceive(timer) { _ in
            updateTimeRemaining()
        }
    }

    private func updateTimeRemaining() {
        let now = Date()
        var components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        components.hour = 19
        components.minute = 05

        var next715 = Calendar.current.date(from: components)!

        if next715 <= now {
            next715 = Calendar.current.date(byAdding: .day, value: 1, to: next715)!
        }

        let interval = next715.timeIntervalSince(now)
        timeRemaining = interval
        displayedTime = timeString(from: interval)
    }

    private func timeString(from interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

#Preview {
    PostTimer()
}
