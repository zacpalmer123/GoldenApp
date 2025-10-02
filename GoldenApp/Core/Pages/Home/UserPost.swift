import SwiftUI

// MARK: - Emoji Picker Grid
struct EmojiPicker: View {
    @Binding var selectedEmoji: String

    let emojis = ["😀", "😂", "🥹", "😍", "😎", "🤩", "😭", "🥳", "😤", "🤯", "🫠", "👻", "💀", "❤️", "🔥", "🌈", "☀️" , "🥵"]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(emojis, id: \.self) { emoji in
                    Button(action: {
                        selectedEmoji += emoji
                    }) {
                        Text(emoji)
                            .font(.system(size: 30))
                            .frame(width: 44, height: 44)
                    }
                }
            }
            .padding()
        }
        .frame(height: 60)
        .glassEffect()
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}

// MARK: - Main View
struct UserPost: View {
    @State private var selectedEmojis: [String] = []
    @State private var showEmojiPicker = false
    @State private var showShareSheet = false
    @State private var showMessageSheet = false
    @State private var currentIndex = 0
    @State private var isLiked = false
    @State private var animateBounce = false
    @State private var likeCount = 12
    @State private var reactionCounts: [String: Int] = ["👍": 4, "🔥": 4, "🐶": 4]
    @State private var reactionPressed: [String: Bool] = ["👍": false, "🔥": false, "🐶": false]

    let images = ["post1.4", "post1","post1.5", "post1.2", "post1.3"]

    var body: some View {
        NavigationStack { // ✅ Wrap the entire content
            ZStack {
                VStack(spacing: 0) {
                    // Image Carousel
                    TabView(selection: $currentIndex) {
                        ForEach(images.indices, id: \.self) { index in
                            GeometryReader { geo in
                                let minX = geo.frame(in: .global).minX
                                let screenWidth = UIScreen.main.bounds.width
                                
                                let scale = max(0.85, 1 - abs(minX) / screenWidth * 0.15)
                                let opacity = max(0.6, 1 - abs(minX) / screenWidth * 0.4)
                                
                                Image(images[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: screenWidth, height: 520)
                                    .clipped()
                                    .cornerRadius(20)
                                    .scaleEffect(scale)
                                    .opacity(opacity)
                                    .animation(.easeInOut(duration: 0.25), value: currentIndex)
                                    .onTapGesture(count: 2) {
                                        handleLikeAnimation()
                                    }
                            }
                            .frame(width: UIScreen.main.bounds.width, height: 520)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 520)
                    
                    // Pagination Dots
                    HStack(spacing: 4) {
                        ForEach(images.indices, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }
                    }
                    .offset(y: -30)
                    
                    // Emoji Picker
                    if showEmojiPicker {
                        EmojiPicker(selectedEmoji: Binding(
                            get: { "" },
                            set: { newEmoji in
                                withAnimation {
                                    if let currentCount = reactionCounts[newEmoji] {
                                        reactionCounts[newEmoji] = currentCount + 1
                                    } else {
                                        reactionCounts[newEmoji] = 1
                                        reactionPressed[newEmoji] = true
                                    }
                                }
                            }
                        ))
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 10)
                    }
                    
                    // Caption + Reactions Row
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 8) {
                            NavigationLink(destination: OtherProfile()) {
                            Image("profile1")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                                .glassEffect()
                                .padding(.leading, 20)
                            
                            // ✅ NavigationLink works now
                            
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Zachary Palmer")
                                        .font(.subheadline).bold()
                                        .foregroundColor(.primary)
                                    Text("This looks really fun!")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                            }
                            
                            
                            Spacer()
                            
                            likeButton
                            commentButton
                            
                            // Default emoji reactions
                            let defaultReactions = ["👍", "🔥", "🐶"]
                            ForEach(defaultReactions, id: \.self) { emoji in
                                reactionButton(emoji: emoji, count: reactionCounts[emoji] ?? 0)
                            }
                            
                            // Dynamic reactions
                            ForEach(reactionCounts.keys.sorted(), id: \.self) { emoji in
                                if !defaultReactions.contains(emoji) {
                                    reactionButton(emoji: emoji, count: reactionCounts[emoji] ?? 1)
                                }
                            }
                            
                            // Emoji Picker Toggle
                            Button(action: {
                                withAnimation {
                                    showEmojiPicker.toggle()
                                }
                            }) {
                                Image(systemName: showEmojiPicker ? "x.circle" : "plus.circle")
                                    .font(.title2)
                                    .foregroundColor(showEmojiPicker ? .red : .primary)
                                    .padding()
                                    .glassEffect()
                            }
                            
                            // Selected emojis
                            ForEach(selectedEmojis, id: \.self) { emoji in
                                Text(emoji)
                                    .font(.title2)
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                    .glassEffect()
                                    .transition(.scale.combined(with: .opacity))
                            }
                            
                            // Share button
                            Button(action: {
                                showShareSheet = true
                            }) {
                                Image(systemName: "paperplane")
                                    .foregroundColor(.primary)
                                    .font(.title2)
                                    .padding()
                                    .glassEffect()
                            }
                            .sheet(isPresented: $showShareSheet) {
                                SharePage()
                                    .presentationDetents([.medium])
                            }
                        }
                        .padding(.trailing, 20)
                    }
                    .frame(height: 100)
                    .offset(y: -10)
                }
            }
            .sheet(isPresented: $showMessageSheet) {
                CommentPage()
                    .presentationDetents([.medium, .large])
            }
        }
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
    
    @ViewBuilder
    private func reactionButton(emoji: String, count: Int) -> some View {
        let isPressed = reactionPressed[emoji] ?? false
        let currentCount = reactionCounts[emoji] ?? count
        
        Button(action: {
            if !isPressed {
                reactionCounts[emoji] = currentCount + 1
                reactionPressed[emoji] = true
            }
        }) {
            HStack(spacing: 4) {
                Text(emoji)
                    .font(.title2)
                Text("\(currentCount)")
                    .font(.headline)
                    .transition(.opacity.combined(with: .scale))
                    .id(currentCount)
            }
            .padding()
            .glassEffect(.regular.tint(isPressed ? .yellow.opacity(0.1) : .clear.opacity(0.2)))
            .foregroundStyle(isPressed ? .yellow : .primary)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    UserPost()
}
