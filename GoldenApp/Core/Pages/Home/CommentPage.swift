//
//  CommentPage.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/4/25.
//

import SwiftUI

struct CommentPage: View {
    @State private var inputText: String = ""
    @State private var comments: [Comment] = [
        Comment(date: "2h", name: "Ethan Hammond", message: "This is beautiful!"),
        Comment(date: "3h", name: "Jack Malo", message: "Wow! Incredible light 🌟"),
        Comment(date: "5h", name: "Josh Powers", message: "Where was this taken?")
    ]
    var onCommentSent: (() -> Void)?
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Comments")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                Spacer()
            }
            .padding([.top, .horizontal], 20)
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(comments) { comment in
                            CommentInteraction(comment: comment)
                        }
                        // Dummy bottom view to scroll to
                        Color.clear
                            .frame(height: 1)
                            .id("Bottom")
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                }
                .onChange(of: comments.count) { _ in
                    // Scroll to bottom when a new comment is added
                    withAnimation {
                        proxy.scrollTo("Bottom", anchor: .bottom)
                    }
                }
            }
            
            HStack(alignment: .center, spacing: 12) {
                // Profile image
                Image("profileE")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 46, height: 46)
                    .clipShape(Circle())
                
                // TextField + send button
                ZStack {
                    TextField("Tell them what you think...", text: $inputText)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                        
                        
                    
                    HStack {
                        Spacer()
                        
                        Button(action: handleSend) {
                            ZStack {
                                Circle()
                                    .fill(inputText.isEmpty ? Color.clear : .blue)
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: inputText.isEmpty ? "mic" : "arrow.up")
                                    .foregroundColor(.primary)
                                    .font(.system(size: 16, weight: .regular))
                            }
                        }
                        .padding(.trailing, 10)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 10)
            
        }
        // Keyboard safe area fix
        .padding(.bottom, 8)
        
    }
    
    func handleSend() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newComment = Comment(date: "Just now", name: "You", message: inputText)
        comments.append(newComment)
        inputText = ""
        
        onCommentSent?()
    }
}

#Preview {
    CommentPage()
}
