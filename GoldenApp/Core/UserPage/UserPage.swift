//
//  UserPage.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 7/31/25.
//

import SwiftUI

struct UserPage: View {
    var body: some View {
        VStack{
            Image("profile1")
                .resizable()
                .cornerRadius(100)
                .glassEffect()
                .frame(width: 120, height: 120)
            Text("Zachary Palmer")
                .font(.system(size: 30, weight: .bold, design: .rounded))
            Rectangle()
                .frame( height: 200)
                .cornerRadius(20)
                .foregroundStyle(.ultraThinMaterial)
        }
        .padding(20)
    }
}

#Preview {
    UserPage()
}
