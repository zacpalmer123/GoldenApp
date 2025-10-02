import SwiftUI
import Combine
import AudioToolbox

class TimeManager: ObservableObject {
    @Published var showCameraView: Bool = false
    @Published var showTimerSheet: Bool = false
    @Published var isInGoldenHour: Bool = false
    private var cancellable: AnyCancellable?
    private var previousCountdownState = false

    init() {
        updateTimeStatus()
        cancellable = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.updateTimeStatus()
            }
    }

    private func updateTimeStatus() {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        var startSunset = calendar.dateComponents([.year, .month, .day], from: now)
        startSunset.hour = 11
        startSunset.minute = 05

        var endSunset = startSunset
        endSunset.hour = 19
        endSunset.minute = 35

        if let start = calendar.date(from: startSunset),
           let end = calendar.date(from: endSunset) {
            isInGoldenHour = now >= start && now <= end
        } else {
            isInGoldenHour = false
        }
        var startComponents = components
        startComponents.hour = 11
        startComponents.minute = 05
        startComponents.second = 0

        var endComponents = components
        endComponents.hour = 19
        endComponents.minute = 05
        endComponents.second = 0

        guard let startTime = calendar.date(from: startComponents),
              let endTime = calendar.date(from: endComponents) else {
            showCameraView = false
            showTimerSheet = false
            return
        }

        let inCountdown = now >= startTime && now <= endTime

        // Show the sheet at the moment the countdown starts
        if inCountdown && !previousCountdownState {
            showTimerSheet = true
            vibrate()
        }

        // Reset sheet if we’re outside the time window
        if !inCountdown {
            showCameraView = false
            showTimerSheet = false
        }

        // Once sheet is shown, transition to camera view after 7 sec
        if showTimerSheet && !showCameraView {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showCameraView = true
                self.showTimerSheet = false
            }
        }

        previousCountdownState = inCountdown
    }

    private func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
