import SwiftUI
import AVKit
import Combine

struct CustomVideoPlayer: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No updates needed
    }
}

struct TestVideoPlayerView: View {
    @State private var player: AVPlayer? = nil
    private var playerLooper: AnyCancellable?

    var body: some View {
        Group {
            if let player = player {
                CustomVideoPlayer(player: player)
                    .onAppear {
                        player.seek(to: .zero)
                        player.play()

                        // Add observer for looping
                        NotificationCenter.default.addObserver(
                            forName: .AVPlayerItemDidPlayToEndTime,
                            object: player.currentItem,
                            queue: .main
                        ) { _ in
                            player.seek(to: .zero)
                            player.play()
                        }
                    }
                    .onDisappear {
                        player.pause()
                        NotificationCenter.default.removeObserver(self)
                    }
                    .ignoresSafeArea()
            } else {
                Text("Video not found")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            if let url = Bundle.main.url(forResource: "river", withExtension: "MOV") {
                player = AVPlayer(url: url)
            } else {
                print("❌ Could not find river.MOV in bundle.")
            }
        }
    }
}
