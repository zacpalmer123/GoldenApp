import SwiftUI

@main
struct GoldenAppApp: App {
    @StateObject private var timeManager = TimeManager()
    @StateObject var cameraManager = CameraManager()
    var body: some Scene {
        WindowGroup {
            ZStack {
                if timeManager.showCameraView {
                    CameraTaker()
                        .transition(.opacity)
                        .environmentObject(cameraManager)
                        .preferredColorScheme(.dark)
                } else {
                    ContentView()
                        .transition(.opacity)
                        
                }
            }
            .sheet(isPresented: $timeManager.showTimerSheet) {
                ItsTimePage()
                    .presentationDetents([.fraction(0.3)])
            }
            .animation(.easeInOut(duration: 1.0), value: timeManager.showCameraView)
            .environmentObject(timeManager)
        }
        
    }
}
