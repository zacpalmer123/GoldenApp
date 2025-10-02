//
//  TimerPage.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/7/25.
//

import SwiftUI

struct TimerPage: View {
    var body: some View {
        VStack{
            
            Text("Sunset starts in:")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            CountdownView()
                .foregroundStyle(.primary)
            
            
        }
    }
        
        
    
}

#Preview {
    TimerPage()
}
