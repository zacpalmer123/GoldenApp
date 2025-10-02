//
//  InteractionComment.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/6/25.
//

import SwiftUI

struct InteractionComment: View {
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
                Text("Wow this is a beautiful picture where was it taken? I think I've...")
                    .font(.caption)
                    .foregroundColor(.gray)
                
            }
            Spacer()
            Image(systemName: "message.fill")
                .foregroundStyle(.green)
                .imageScale(.small)
            Image("post1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(5)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    InteractionComment()
}
