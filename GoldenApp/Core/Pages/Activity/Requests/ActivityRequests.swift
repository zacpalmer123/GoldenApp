//
//  ActivityRequests.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/6/25.
//

import SwiftUI

struct ActivityRequests: View {
    var body: some View {
        HStack {
            Text("All")
                .font(.system(size: 15, weight: .bold, design: .rounded))
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        ForEach(100..<104, id: \.self){ _ in
            InteractRequests()
                .padding(.bottom, 15)
        }
        
        
    }
}

#Preview {
    ActivityRequests()
}
