//
//  ProfilePosts1.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 7/31/25.
//

import SwiftUI

struct ProfilePosts1: View {
    var body: some View {
        VStack{
            let images = ["post1.2", "post2", "post2.2", "post1", "post1.3", "post1", "post1.2", "post1", "post2.2"]
            let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(images, id: \.self) { name in
                    Image(name)
                        .resizable()
                    
                        .aspectRatio(contentMode: .fill)
                        
                        .cornerRadius(12)
                        .clipped()
                }
            }
            .padding(.horizontal, 20)
        }
        
    }
}

#Preview {
    ProfilePosts1()
}
