//
//  ActivityLikes.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/6/25.
//

import SwiftUI

struct ActivityLikes: View {
    var body: some View {
        HStack {
            Text("Today")
                .font(.system(size: 15, weight: .bold, design: .rounded))
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        ForEach(0..<4, id: \.self){ _ in
            Interaction()
                .padding(.bottom, 15)
        }
        HStack{
            Text("Yesterday")
                .font(.system(size: 15, weight: .bold, design: .rounded))
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        ForEach(5..<12, id: \.self){ _ in
            InteractionYesterday()
                .padding(.bottom, 15)
        }
    }
}

#Preview {
    ActivityLikes()
}
