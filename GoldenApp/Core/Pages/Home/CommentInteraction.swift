//
//  CommentInteraction.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/5/25.
//

import SwiftUI

struct CommentInteraction: View {
    @State private var isLiked = false
    @State private var animateBounce = false
    @State private var likes = 0

    private func handleLikeAnimation() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0)) {
            animateBounce = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            animateBounce = false
        }
    }

    var body: some View {
        HStack {
            Image("profile1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(200)
                .glassEffect()

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Zachary Palmer")
                        .font(.subheadline).bold()
                    Text("12:34")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text("Wow this is a very pretty post, where was it taken? I think I've been there.")
                    .font(.caption)
            }

            Spacer()

            Button(action: {
                isLiked.toggle()
                if isLiked {
                    likes += 1
                } else {
                    likes -= 1
                }
                handleLikeAnimation()
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(isLiked ? .pink : .primary)
                    .scaleEffect(animateBounce ? 1.4 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.3), value: animateBounce)
            }

            Text("\(likes)")
                .font(.caption)
        }
    }
}

#Preview {
    CommentInteraction()
}
