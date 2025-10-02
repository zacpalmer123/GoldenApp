//
//  BlockedSheet.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/7/25.
//

import SwiftUI

struct BlockedSheet: View {
    var body: some View {
        ScrollView{
            LazyVStack{
                HStack {
                    Text("Blocked Users")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                HStack {
                    Text("All")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                ForEach(0..<4, id: \.self){ _ in
                    BlockedInteraction()
                        .padding(.bottom, 10)
                }
                
            }
            Spacer()
        }
    }
}

#Preview {
    BlockedSheet()
}
