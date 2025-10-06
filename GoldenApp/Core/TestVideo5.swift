import SwiftUI
import AVKit
import PhotosUI

struct VideoPickerView: View {
    @State private var selectedVideo: URL? = nil
    @State private var showVideoPicker = false
    @State private var player: AVPlayer? = nil
    
    var body: some View {
        ZStack {
            if let player = player {
                PlayerLayerView(player: player)
                    .onAppear {
                        player.seek(to: .zero)
                        player.play()
                        // Loop video
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
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundColor(.black)
            }
            
            if player == nil { // Show button only when no video selected
                VStack {
                    Spacer()
                    Button(action: {
                        showVideoPicker = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 150)
                }
            }
        }
        .sheet(isPresented: $showVideoPicker) {
            VideoPicker(videoURL: $selectedVideo)
        }
        .onChange(of: selectedVideo) { newURL in
            guard let url = newURL else { return }
            player = AVPlayer(url: url)
        }
        .environment(\.colorScheme, .dark)
    }
}

// MARK: - PlayerLayerView
struct PlayerLayerView: UIViewRepresentable {
    var player: AVPlayer
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        playerLayer.frame = UIScreen.main.bounds
        view.isUserInteractionEnabled = false // touches pass through
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}

// MARK: - VideoPicker
struct VideoPicker: UIViewControllerRepresentable {
    @Binding var videoURL: URL?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .videos
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: VideoPicker
        init(_ parent: VideoPicker) { self.parent = parent }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let itemProvider = results.first?.itemProvider else { return }
            
            if itemProvider.hasItemConformingToTypeIdentifier("public.movie") {
                itemProvider.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, _ in
                    guard let url = url else { return }
                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                    try? FileManager.default.removeItem(at: tempURL)
                    do {
                        try FileManager.default.copyItem(at: url, to: tempURL)
                        DispatchQueue.main.async {
                            self.parent.videoURL = tempURL
                        }
                    } catch {
                        print("Error copying video: \(error)")
                    }
                }
            }
        }
    }
}



// MARK: - Preview
struct VideoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPickerView()
            .environment(\.colorScheme, .dark)
    }
}
