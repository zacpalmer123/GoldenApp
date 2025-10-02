//
//  BlockedInteraction.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/7/25.
//

import SwiftUI

struct BlockedInteraction: View {
    var body: some View {
        HStack{
            Image("profile1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(200)
                .glassEffect()
            VStack(alignment: .leading, spacing: 4){
                Text("Zachary Palmer")
                    .font(.subheadline).bold()
                    .foregroundColor(.primary)
                Text("Blocked")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .foregroundColor(.primary)
                
            }
            Spacer()
            Button(action: {
                print("requested")
            }) {
                Text("Unblock")
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .foregroundColor(.white)
                    .background(Color.red.opacity(0.8))
                    .clipShape(Capsule())
                    .glassEffect()
                    
            }
            
            
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    BlockedInteraction()
}
