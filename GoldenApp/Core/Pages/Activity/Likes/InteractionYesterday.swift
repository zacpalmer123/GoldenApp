//
//  InteractionYesterday.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/5/25.
//

import SwiftUI

struct InteractionYesterday: View {
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
                    Text("Liked at 12:34")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                }
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundStyle(.pink)
                    .imageScale(.small)
                Image("post2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
            }
            .padding(.horizontal, 20)
        }
    
}

#Preview {
    InteractionYesterday()
}
