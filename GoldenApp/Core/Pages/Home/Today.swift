//
//  Today.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/1/25.
//

import SwiftUI

struct Today: View {
    var body: some View {
        ForEach(0..<20, id: \.self){ _ in
            UserPost()
                .padding(.bottom, 40)
                
        }
    }
}

#Preview {
    Today()
}
