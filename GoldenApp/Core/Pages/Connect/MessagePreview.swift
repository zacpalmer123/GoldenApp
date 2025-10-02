//
//  MessagePreview.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 7/31/25.
//

import SwiftUI

struct MessagePreview: View {
    var body: some View {
        
        HStack{
            Image("profile1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(100)
                .glassEffect()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading){
                HStack{
                    Text("Username")
                    Spacer()
                    Text("12:34 AM")
                }
                Text("This is where the message from a differnt user is previewed...")
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    MessagePreview()
}

