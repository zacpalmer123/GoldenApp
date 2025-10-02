//
//  InteractRequests.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/6/25.
//

import SwiftUI

struct InteractRequests: View {
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
                Text("Requested at 12:34")
                    .font(.caption)
                    .foregroundColor(.gray)
                
            }
            Spacer()
            Button(action: {
                print("requested")
            }) {
                Text("Confirm")
                    .padding(8)
                    .foregroundColor(.white)
                    .background(Color.blue.opacity(0.7))
                    .clipShape(Capsule())
                    .glassEffect()
                    
            }
            Button(action: {
                print("requested")
            }) {
                Text("Delete")
                    .padding(8)
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.7))
                    .clipShape(Capsule())
                    .glassEffect()
                    
            }
            
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    InteractRequests()
}
