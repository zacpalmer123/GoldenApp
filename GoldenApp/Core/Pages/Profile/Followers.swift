//
//  Followers.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 10/1/25.
//

import SwiftUI

struct Followers: View {
    var body: some View {
        HStack {
            Text("All Followers")
                .font(.system(size: 15, weight: .bold, design: .rounded))
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        ForEach(0..<10, id: \.self){ _ in
            FollowersPreview()
                .padding(.bottom, 15)
        }
        
    }
}

#Preview {
    Followers()
}
