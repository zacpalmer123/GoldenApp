//
//  ActivityComments.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/6/25.
//

import SwiftUI

struct ActivityComments: View {
    var body: some View {
        HStack {
            Text("Today")
                .font(.system(size: 15, weight: .bold, design: .rounded))
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        ForEach(50..<56, id: \.self){ _ in
            InteractionComment()
                .padding(.bottom, 15)
        }
        HStack{
            Text("Yesterday")
                .font(.system(size: 15, weight: .bold, design: .rounded))
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        ForEach(57..<61, id: \.self){ _ in
            InteractionComment()
                .padding(.bottom, 15)
        }
    }
}

#Preview {
    ActivityComments()
}
