import SwiftUI
import Combine
import UserNotifications

struct CountdownView: View {
    @State private var timeRemaining: TimeInterval = 0
    @State private var displayedTime: String = ""
    @State private var isCountdownFinished = false
    var fontSize: CGFloat = 45
    let timer = Timer.publish(every: 1, on: RunLoop.main, in: .common).autoconnect()
    @State private var notificationScheduled = false

    var body: some View {
        VStack(spacing: 20) {
            Text(displayedTime)
                .font(.system(size: fontSize, weight: .bold, design: .rounded).monospacedDigit())
                .transition(.scale(scale: 0.8).combined(with: .opacity))
                .id(displayedTime)
                .animation(.easeInOut(duration: 0.3), value: displayedTime)
        }
        .onAppear {
            requestNotificationPermission()
            updateTime()
        }
        .onReceive(timer) { _ in
            updateTime()
        }
    }

    private func updateTime() {
        let now = Date()
        if !isCountdownFinished {
            // Target countdown time
            var components = Calendar.current.dateComponents([.year, .month, .day], from: now)
            components.hour = 18
            components.minute = 10
            components.second = 0
            let targetTime = Calendar.current.date(from: components)!

            let interval = targetTime > now
                ? targetTime.timeIntervalSince(now)
                : 0 // countdown reached

            timeRemaining = interval
            displayedTime = timeString(from: interval)

            if interval <= 0 {
                isCountdownFinished = true
            }

            // Schedule notification once
            if !notificationScheduled {
                scheduleDailyNotification(hour: 11, minute: 5)
                notificationScheduled = true
            }
        } else {
            // After countdown finished, show next interval until next target
            displayedTime = nextTargetTimeString()
        }
    }

    private func nextTargetTimeString() -> String {
        let now = Date()
        var components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        components.hour = 18
        components.minute = 10
        components.second = 0
        var nextTarget = Calendar.current.date(from: components)!

        if nextTarget <= now {
            nextTarget = Calendar.current.date(byAdding: .day, value: 1, to: nextTarget)!
        }

        let interval = nextTarget.timeIntervalSince(now)
        return timeString(from: interval)
    }

    private func timeString(from interval: TimeInterval) -> String {
        let totalSeconds = max(Int(interval), 0)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    private func scheduleDailyNotification(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Golden"
        content.body = "It's sunset, let's see what you got!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0
        dateComponents.timeZone = TimeZone.current

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "DailyCountdownNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification scheduling error: \(error.localizedDescription)")
            } else {
                print("✅ Daily notification scheduled at \(hour):\(String(format: "%02d", minute))")
            }
        }
    }
}
