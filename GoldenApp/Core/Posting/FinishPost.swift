//
//  FinishPost.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/19/25.
//

import SwiftUI

struct FinishPost: View {
    var body: some View {
        NavigationStack {
            ZStack{
                Gradient()
                    
                VStack(spacing: 10){
                    Spacer()
                    Text("Wow you look great!")
                        .foregroundStyle(.white)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                    Text("Posts go live in")
                        .foregroundStyle(.white)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                    PostTimer()
                        .foregroundStyle(.white)
                    Spacer()
                    
                }
            }
        }
    }
}

#Preview {
    FinishPost()
}
