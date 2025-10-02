//
//  CommentPage.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/4/25.
//

import SwiftUI

struct CommentPage: View {
    @State private var inputText = ""
    
    var body: some View {
        VStack{
            ScrollView {
                LazyVStack(spacing: 0) {
                    
                    // Header
                    HStack {
                        Text("Comments")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    ForEach(0..<3, id: \.self){ _ in
                        CommentInteraction()
                            .padding(.bottom, 10)
                        
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    
                }
                .scrollIndicators(.hidden)
                
            }
            Spacer()
            ZStack{
                TextField("Tell them what you think...", text: $inputText)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(.ultraThickMaterial)
                            .glassEffect()
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                    )
                
                HStack{
                    Spacer()
                    ZStack{
                        Rectangle()
                            .frame(width: 50, height: 35)
                            .foregroundColor(.blue)
                            .cornerRadius(20)
                        Image(systemName: "arrow.up")
                            .foregroundStyle(.white)
                    }
                    
                }
                .padding(13)
                
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    CommentPage()
}
