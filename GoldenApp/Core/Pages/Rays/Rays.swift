import SwiftUI
import AVKit

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
        @State private var player: AVPlayer?
    @State private var isLiked = false
    @State private var likeCount = 42
    @State private var animateBounce = false
    @State private var showMessageSheet = false
    @State private var showShareSheet = false
    @State private var showEmojiPicker = false
    @State private var selectedEmojis: [String] = []
    
    // ✅ Reaction states
    @State private var reactionCounts: [String: Int] = ["👍": 3, "🔥": 5, "🐶": 1]
    @State private var reactionPressed: [String: Bool] = [:]
    
    private let screen = UIScreen.main.bounds
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(imageNames, id: \.self) { imageName in
                    ZStack {
                        // Full-screen background image
                        TestVideoPlayerView()
                        
                        // Overlay content (bottom bar)
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
                                                    .shadow(
                                                        color: Color.black.opacity(0.9), /// shadow color
                                                        radius: 6, /// shadow radius
                                                        x: 0, /// x offset
                                                        y: 0 /// y offset
                                                    )
                                                Text("This looks really fun!")
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)
                                                    .shadow(
                                                        color: Color.black.opacity(0.9), /// shadow color
                                                        radius: 6, /// shadow radius
                                                        x: 0, /// x offset
                                                        y: 0 /// y offset
                                                    )
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    // Like + comment
                                    likeButton
                                    commentButton
                                    
                                    // Default emoji reactions
                                    let defaults = ["👍", "🔥", "🐶"]
                                    ForEach(defaults, id: \.self) { emoji in
                                        reactionButton(emoji: emoji, count: reactionCounts[emoji] ?? 0)
                                    }
                                    
                                    // Extra reactions
                                    ForEach(reactionCounts.keys.sorted(), id: \.self) { emoji in
                                        if !defaults.contains(emoji) {
                                            reactionButton(emoji: emoji, count: reactionCounts[emoji] ?? 1)
                                        }
                                    }
                                    
                                    // Emoji Picker Toggle
                                    Button(action: {
                                        withAnimation { showEmojiPicker.toggle() }
                                    }) {
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
                                    .padding()
                                    .glassEffect()
                                    // Share
                                    Button(action: { showShareSheet = true }) {
                                        Image(systemName: "paperplane")
                                            .foregroundColor(.white)
                                            .font(.title2)
                                            .padding()
                                            
                                            .glassEffect()
                                    }
                                    .sheet(isPresented: $showShareSheet) {
                                        SharePage()
                                            .presentationDetents([.medium])
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 100)
                            }
                        }
                        
                        // Optional emoji picker appearing above reactions
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
                    .frame(width: screen.width, height: screen.height)
                }
            }
        }
        .ignoresSafeArea()
        //.scrollEdgeEffectDisabled()
        .scrollTargetBehavior(.paging)
    }
    
    // MARK: - Buttons
    
    private var likeButton: some View {
        Button(action: { handleLikeAnimation() }) {
            HStack {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(isLiked ? .pink : .white)
                    .font(.title2)
                    .scaleEffect(animateBounce ? 1.4 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.3), value: animateBounce)
                
                Text("\(likeCount)")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .glassEffect()
        }
        .buttonStyle(.plain)
    }
    
    private var commentButton: some View {
        Button(action: { showMessageSheet = true }) {
            HStack {
                Image(systemName: "message")
                    .foregroundColor(.white)
                    .font(.title2)
                Text("4")
                    .font(.headline)
                    .foregroundColor(.white)
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
    
    // MARK: - Like Animation
    
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

#Preview {
    Rays()
}
