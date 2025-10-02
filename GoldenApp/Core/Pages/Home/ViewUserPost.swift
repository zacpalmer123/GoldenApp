//
//  ViewUserPost.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 9/17/25.
//

import SwiftUI

struct ViewUserPost: View {
    @State private var isLiked = false
    @State private var likeCount = 12
    @State private var animateBounce = false
    @State private var showMessageSheet = false
    @State private var showShareSheet = false
    @State private var currentIndex = 0
    @State private var isPressed = false
    @State private var isExpanded = false
    @State var showActivitySheet: Bool = false
    @State var showProfileSheet: Bool = false
    @State private var reactionCounts: [String: Int] = ["👍": 4, "🔥": 4, "🐶": 4]
    @State private var reactionPressed: [String: Bool] = ["👍": false, "🔥": false, "🐶": false]
    let images = ["post1", "post1.2", "post1.3"]
    
    private func handleLikeAnimation() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0)) {
            animateBounce = true
            isLiked.toggle()
            likeCount += isLiked ? 1 : -1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            animateBounce = false
        }
    }
    
    var body: some View {
        ZStack {
        
            VStack(spacing: 0) {
                
                // 🖼 Animated Image Carousel
                TabView(selection: $currentIndex) {
                    ForEach(images.indices, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:UIScreen.main.bounds.width, height: 520)
                            .clipped()
                            .cornerRadius(20)
                            .scaleEffect(currentIndex == index ? 1 : 0.85)
                            .opacity(currentIndex == index ? 1 : 0.5)
                            .animation(.easeInOut(duration: 0.3), value: currentIndex)
                            .onTapGesture(count: 2) {
                                handleLikeAnimation()
                            }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 520)
                
                
                // 🔘 Pagination Dots
                HStack(spacing: 4) {
                    ForEach(images.indices, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.primary : Color.secondary.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
                .offset(y: -30)
                
                // 🧾 Caption + Reactions Scroll Row
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        
                        // 👤 Profile
                        Image("profile1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                            .glassEffect()
                            .padding(.leading, 20)
                        
                        // 📝 Name & Caption
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Zachary Palmer")
                                .font(.subheadline).bold()
                            Text("This looks really fun!")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        // ❤️ Like Button
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
                                    .id(likeCount) // Triggers transition when value changes
                            }
                            .padding()
                            .glassEffect(.regular.tint(isLiked ? .pink.opacity(0.25) : .clear.opacity(0.2)))
                            .foregroundStyle(isLiked ? .pink : .primary)
                            .contentShape(Rectangle()) // Improves tap area
                        }
                        .buttonStyle(.plain)
                        
                        // 💬 Message
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
                        .sheet(isPresented: $showMessageSheet) {
                            CommentPage()
                                .presentationDetents([.medium, .large])
                        }
                        
                        // 🧡 Reactions
                        reactionButton(emoji: "👍", count: 4)
                        reactionButton(emoji: "🔥", count: 4)
                        reactionButton(emoji: "🐶", count: 4)
                        
                        // 📤 Share
                        Button(action: {
                            showShareSheet = true
                        }) {
                            Image(systemName: "paperplane")
                                .font(.title2)
                                .padding()
                                .glassEffect()
                        }
                        .buttonStyle(.plain)
                        .sheet(isPresented: $showShareSheet) {
                            SharePage()
                                .presentationDetents([.medium])
                        }
                    }
                }
                .frame(height: 100)
                .offset(y: -10)
                //.background(Color.blue)
            }
            
            .padding(.top, 40)
        }
        .toolbar{
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    showProfileSheet = true
                }) {
                    Image(systemName: "paperplane")
                        .symbolRenderingMode(.multicolor)
                        .foregroundColor(.primary)
                }
                .sheet(isPresented: $showProfileSheet) {
                    ProfileSheet()
                        .presentationDetents([.fraction(0.5)]) // or .height(200)
                        .presentationDragIndicator(.hidden)
                }
                
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    showProfileSheet = true
                }) {
                    Image(systemName: "ellipsis")
                        .symbolRenderingMode(.multicolor)
                        .foregroundColor(.primary)
                }
                .sheet(isPresented: $showProfileSheet) {
                    ProfileSheet()
                        .presentationDetents([.fraction(0.5)]) // or .height(200)
                        .presentationDragIndicator(.hidden)
                }
                
            }
        }
    }
       
    
    // 🔁 Reaction Button Builder
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
    ViewUserPost()
}
