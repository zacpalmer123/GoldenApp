import SwiftUI
import AVKit
import PhotosUI

struct VideoPlayerView: View {
    private var player: AVPlayer {
        guard let url = Bundle.main.url(forResource: "myVideo", withExtension: "mov") else {
            fatalError("Video not found")
        }
        return AVPlayer(url: url)
    }

    var body: some View {
        VideoPlayer(player: player)
            .ignoresSafeArea()
    }
}

struct Rays: View {
    let imageNames = ["post1.5", "post1.4", "post1"]
    
    @State private var currentPlayer: AVPlayer? = nil
    
    @State private var showVideoPicker = false
    @State private var selectedVideoItem: PhotosPickerItem? = nil
    
    @StateObject private var videoManager = VideoPlayerManager()
    @State private var currentIndex = 0
    
    @State private var isLiked = false
    @State private var likeCount = 42
    @State private var animateBounce = false
    @State private var showMessageSheet = false
    @State private var showShareSheet = false
    @State private var showEmojiPicker = false
    @State private var selectedEmojis: [String] = []
    
    @State private var reactionCounts: [String: Int] = ["👍": 3, "🔥": 5, "🐶": 1]
    @State private var reactionPressed: [String: Bool] = [:]
    
    private let screen = UIScreen.main.bounds
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(imageNames.indices, id: \.self) { index in
                    GeometryReader { geo in
                        let minY = geo.frame(in: .global).minY
                        let height = geo.size.height
                        
                        ZStack {
                            // Video layer
                            Color.black.ignoresSafeArea()
                            if let player = currentPlayer, currentIndex == index {
                                VideoContainerView(player: player)
                                    .ignoresSafeArea()
                                    .environment(\.colorScheme, .dark)
                            }
                            
                            // Overlay UI (buttons, reactions, etc)
                            VStack {
                                Spacer()
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(alignment: .bottom, spacing: 12) {
                                        // Profile + caption
                                        NavigationLink(destination: OtherProfile()) {
                                            HStack(spacing: 12) {
                                                Image("profile1")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 55, height: 55)
                                                    .clipShape(Circle())
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("Zachary Palmer")
                                                        .font(.subheadline).bold()
                                                        .foregroundColor(.white)
                                                        .shadow(color: .black.opacity(0.9), radius: 6)
                                                    Text("This looks really fun!")
                                                        .font(.subheadline)
                                                        .foregroundColor(.white)
                                                        .shadow(color: .black.opacity(0.9), radius: 6)
                                                }
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        // Floating video picker button
                                        
                                        
                                        // Like + Comment + Reactions
                                        likeButton
                                        commentButton
                                        Button(action: { showVideoPicker = true }) {
                                            Image(systemName: "plus")
                                                .font(.title2)
                                                .foregroundColor(.primary)
                                                .padding()
                                                .glassEffect()
                                        }
                                        let defaults = ["👍", "🔥", "🐶"]
                                        ForEach(defaults, id: \.self) { emoji in
                                            reactionButton(emoji: emoji, count: reactionCounts[emoji] ?? 0)
                                        }
                                        
                                        ForEach(reactionCounts.keys.sorted(), id: \.self) { emoji in
                                            if !defaults.contains(emoji) {
                                                reactionButton(emoji: emoji, count: reactionCounts[emoji] ?? 1)
                                            }
                                        }
                                        
                                        // Emoji Picker toggle
                                        Button(action: { withAnimation { showEmojiPicker.toggle() } }) {
                                            Image(systemName: showEmojiPicker ? "x.circle" : "plus.circle")
                                                .font(.title2)
                                                .foregroundColor(showEmojiPicker ? .red : .white)
                                                .padding()
                                                .glassEffect()
                                        }
                                        
                                        // Selected emojis
                                        ForEach(selectedEmojis, id: \.self) { emoji in
                                            Text(emoji)
                                                .font(.title2)
                                                .clipShape(Circle())
                                                .transition(.scale.combined(with: .opacity))
                                                .padding()
                                                .glassEffect()
                                        }
                                        
                                        // Share button
                                        Button(action: { showShareSheet = true }) {
                                            Image(systemName: "paperplane")
                                                .foregroundColor(.white)
                                                .font(.title2)
                                                .padding()
                                                .glassEffect()
                                        }
                                        .sheet(isPresented: $showShareSheet) {
                                            SharePage().presentationDetents([.medium])
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 100)
                                }
                            }
                            
                            // Optional emoji picker above reactions
                            if showEmojiPicker {
                                VStack {
                                    EmojiPicker(selectedEmoji: Binding(
                                        get: { "" },
                                        set: { newEmoji in
                                            withAnimation {
                                                if let current = reactionCounts[newEmoji] {
                                                    reactionCounts[newEmoji] = current + 1
                                                } else {
                                                    reactionCounts[newEmoji] = 1
                                                    reactionPressed[newEmoji] = true
                                                }
                                            }
                                        }
                                    ))
                                    Spacer()
                                }
                                .padding(.top, 80)
                            }
                        }
                        .onChange(of: minY) { _ in
                            // Play video if mostly visible
                            if minY < screen.height * 0.25 && minY > -height * 0.75 {
                                if currentIndex != index {
                                    currentIndex = index
                                    loadVideo(at: index)
                                }
                            }
                        }
                    }
                    .frame(width: screen.width, height: screen.height)
                }
            }
            
        }
        .ignoresSafeArea()
        .scrollEdgeEffectDisabled()
        .sheet(isPresented: $showMessageSheet) {
            CommentPage()
                .presentationDetents([.medium, .large])
                .environment(\.colorScheme, .dark)
        }
        
        .scrollTargetBehavior(.paging)
        .photosPicker(isPresented: $showVideoPicker, selection: $selectedVideoItem, matching: .videos)
        .onChange(of: selectedVideoItem) { newItem in
            guard let item = newItem else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mov")
                    if (try? data.write(to: tempURL)) != nil {
                        currentPlayer?.pause()
                        currentPlayer = AVPlayer(url: tempURL)
                        currentPlayer?.play()
                    }
                }
                
            }
            
        }
        .environment(\.colorScheme, .dark)
    }
    
    
    // MARK: - Load video for current post
    private func loadVideo(at index: Int) {
        guard let url = Bundle.main.url(forResource: "myVideo", withExtension: "mov") else { return }
        
        // Pause old player
        currentPlayer?.pause()
        
        // Create new player
        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .none
        currentPlayer = player
        
        // Remove old observers before adding a new one
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem,
                                               queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        // Start playback immediately
        player.play()
    }
    
    // MARK: - Buttons
    
    private var likeButton: some View {
        Button(action: {
            handleLikeAnimation()
        }) {
            HStack(spacing: 6) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(isLiked ? .pink : .primary)
                    .font(.title2)
                    .scaleEffect(animateBounce ? 1.4 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.3), value: animateBounce)
                
                Text("\(likeCount)")
                    .font(.headline)
                    .transition(.opacity.combined(with: .scale))
                    .id(likeCount)
            }
            .padding()
            .glassEffect(.regular.tint(isLiked ? .pink.opacity(0.25) : .clear.opacity(0.2)))
            .foregroundStyle(isLiked ? .pink : .primary)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    private var commentButton: some View {
        Button(action: {
            showMessageSheet = true
        }) {
            HStack {
                Image(systemName: "message")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.primary)
                    .font(.title2)
                Text("4")
            }
            .padding()
            .glassEffect()
        }
        .buttonStyle(.plain)
    }
    
    private func reactionButton(emoji: String, count: Int) -> some View {
        let isPressed = reactionPressed[emoji] ?? false
        let current = reactionCounts[emoji] ?? count
        return Button(action: {
            if !isPressed {
                reactionCounts[emoji] = current + 1
                reactionPressed[emoji] = true
            }
        }) {
            HStack(spacing: 4) {
                Text(emoji).font(.title2)
                Text("\(current)").font(.headline)
                    .id(current)
                    .transition(.opacity.combined(with: .scale))
            }
            .padding()
            .glassEffect()
            .foregroundStyle(isPressed ? .yellow : .white)
        }
        .buttonStyle(.plain)
    }
    
    private func handleLikeAnimation() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) {
            animateBounce = true
            isLiked.toggle()
            likeCount += isLiked ? 1 : -1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            animateBounce = false
        }
    }
}

struct VideoContainerView: UIViewRepresentable {
    let player: AVPlayer?
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        view.isUserInteractionEnabled = false
        
        if let player = player {
            let layer = AVPlayerLayer(player: player)
            layer.videoGravity = .resizeAspectFill
            layer.frame = UIScreen.main.bounds
            view.layer.addSublayer(layer)
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let player = player else { return }
        
        if let layer = uiView.layer.sublayers?.first as? AVPlayerLayer {
            layer.player = player
        } else {
            let layer = AVPlayerLayer(player: player)
            layer.frame = UIScreen.main.bounds
            layer.videoGravity = .resizeAspectFill
            uiView.layer.addSublayer(layer)
        }
        player.isMuted = true
        // Ensure looping
        player.actionAtItemEnd = .none
        NotificationCenter.default.removeObserver(uiView, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem,
                                               queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        player.play()
    }
}

#Preview {
    Rays()
        .environment(\.colorScheme, .dark)
}
