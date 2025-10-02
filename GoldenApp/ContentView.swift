//
//  ContentView.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 7/31/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Group {
            if #available(iOS 26, *){
                MyTabView()
            }
            else{
                MyTabView()
            }
        }
    }
    
}

#Preview {
    ContentView()
        .environmentObject(TimeManager())
}
