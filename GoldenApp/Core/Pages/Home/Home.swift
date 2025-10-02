//
//  Home.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 7/31/25.
//

import SwiftUI

struct Home: View {
    @State private var showSettings = false
    @State private var showMeshGradient = true
    @State private var selectedDay: Day = .today
    @State private var isExpanded = false
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoading = false
    @State private var data = ["Item 1", "Item 2", "Item 3"]
    @State private var currentImageIndex = 0
        let allImages = ["post1", "post1.2", "post1.3"]
    @EnvironmentObject var timeManager: TimeManager

    enum Day {
        case yesterday, today, foryou
    }
    
    var primaryColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var secondaryColor: Color {
        .gray
    }
    
    func loadData() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        data.append("New Item \(data.count + 1)")
        isLoading = false
    }
    
    
    var body: some View {
        ZStack{
            if timeManager.isInGoldenHour {
                AnimatedMeshGradient()
                    .opacity(0.6)
                    .transition(.opacity)
                    .offset(y: -200)
            }

            ScrollView {
                LazyVStack(spacing: 0) {
                    
                    // Track scroll offset
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self,
                                        value: geometry.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0)
                    
                    // Day selection buttons
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedDay = .yesterday
                            }
                        }) {
                            Text("Yesterday")
                                .font(.system(size: selectedDay == .yesterday ? 25 : 20, weight: .bold, design: .rounded))
                                .foregroundStyle(selectedDay == .yesterday ? primaryColor : secondaryColor)
                        }
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedDay = .today
                            }
                        }) {
                            Text("Today")
                                .font(.system(size: selectedDay == .today ? 25 : 20, weight: .bold, design: .rounded))
                                .foregroundStyle(selectedDay == .today ? primaryColor : secondaryColor)
                        }
                        
                        Spacer()
                        
                    }
                    .foregroundColor(.clear)
                    .padding(20)
                    
                    // Conditionally show selected view
                    Group {
                        switch selectedDay {
                        case .today:
                            HomeToday()
                        case .yesterday:
                            HomeYesterday()
                        case .foryou:
                            Text("For You view not implemented")
                        }
                    }
                }
            }
            
            .scrollIndicators(.hidden)
            .coordinateSpace(name: "scroll")
            .refreshable {
                await loadData()
            }
        }
    }
}

#Preview {
    Home()
        .environmentObject(TimeManager())
}
