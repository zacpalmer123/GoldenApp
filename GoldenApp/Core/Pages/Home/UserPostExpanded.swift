//
//  UserPostExpanded.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/1/25.
//

import SwiftUI

struct UserPostExpanded: View {
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                // Background Image
                Image("post1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea(.all)

                // Overlay Content
                VStack {
                    
                    Spacer()

                    HStack(alignment: .center, spacing: 12) {
                        Image("profile1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .glassEffect()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("@username")
                                .font(.subheadline).bold()
                                
                            Text("User caption here...")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }

                        Spacer()

                        // Action Buttons
                        ForEach(["heart", "message", "paperplane"], id: \.self) { icon in
                            ZStack {
                                
                                Image(systemName: icon)
                                    
                                    .frame(width: 36, height: 36)
                                    .glassEffect()
                                
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                    
                }
            }
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    UserPostExpanded()
}
