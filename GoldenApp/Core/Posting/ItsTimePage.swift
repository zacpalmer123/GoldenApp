//
//  ItsTimePage.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/8/25.
//

import SwiftUI

struct ItsTimePage: View {
    var body: some View {
        ZStack{
            FullScreenAnimatedMeshGradient()
            Text("Its Sunset, are you ready?")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding()
        }
        
    }
}

#Preview {
    ItsTimePage()
}
