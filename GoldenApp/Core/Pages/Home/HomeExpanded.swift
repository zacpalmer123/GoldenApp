//
//  HomeExpanded.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/1/25.
//

import SwiftUI

struct HomeExpanded: View {
    @Environment(\.colorScheme) var colorScheme

    @State private var selectedDay: Day = .today
    
    enum Day {
        case yesterday, today
    }

    var primaryColor: Color {
        colorScheme == .dark ? .white : .black
    }

    var secondaryColor: Color {
        .gray
    }

    var body: some View {
        ScrollView {
            LazyVStack{
                ForEach(0..<20, id: \.self) { _ in
                    UserPostExpanded()
                        .frame(width: .infinity, height: 855)
                }
            }
        }
        
        
        .ignoresSafeArea()
    }
}

#Preview {
    HomeExpanded()
}
