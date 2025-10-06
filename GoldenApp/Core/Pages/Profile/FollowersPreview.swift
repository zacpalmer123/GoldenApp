//
//  ProfilePreview.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 10/1/25.
//

import SwiftUI

struct FollowersPreview: View {
    var body: some View {
        HStack{
            Image("profileEH")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(200)
                .glassEffect()
            VStack(alignment: .leading, spacing: 4){
                Text("Ethan Hammond")
                    .font(.subheadline).bold()
                    .foregroundColor(.primary)
                Text("@ethanhammond3")
                    .font(.caption)
                    .foregroundColor(.gray)
                
            }
            Spacer()
            Image(systemName:"ellipsis")
                
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    FollowersPreview()
}
