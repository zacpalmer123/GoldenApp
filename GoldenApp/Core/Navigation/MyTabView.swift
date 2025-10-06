//
//  MyTabView.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 7/31/25.
//

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
enum ActiveSheet: Identifiable {
    case golden, activity, timer, profile, follow
    
    var id: Int {
        hashValue
    }
}
struct MyTabView: View {
    @State private var activeSheet: ActiveSheet?
    @State var showProfileSheet: Bool = false
    @State var showTimerSheet: Bool = false
    @State private var showCountdown = false
    @State private var scrollOffset: CGFloat = 0
    @State private var hasScrolled = false
    @State private var isAtTop: Bool = true
    @State private var selectedOption = "All"
    let options = ["Everyone", "Friends"]
    var body: some View {
        TabView {
            Tab("Home", systemImage: "sun.max") {
                NavigationStack {
                    Home()
                        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                            print("Scroll offset: \(value)")
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if value < -10 {
                                    hasScrolled = true
                                }
                                scrollOffset = value
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    activeSheet = .golden
                                }) {
                                    Image(systemName: "sun.max.fill")
                                        .symbolRenderingMode(.multicolor)
                                }
                            }
                            ToolbarSpacer(.fixed, placement: .navigationBarLeading)
                            ToolbarItem(placement: .cancellationAction) {
                                Button(action: {
                                    activeSheet = .timer
                                }) {
                                    ZStack {
                                        CountdownView(fontSize: 20)
                                            .frame(width: 115)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                            
                            ToolbarItem(placement: .primaryAction) {
                                Button(action: {
                                    activeSheet = .activity
                                }) {
                                    Image(systemName: "bell.badge")
                                        .symbolRenderingMode(.multicolor)
                                        .foregroundColor(.primary)
                                }
                            }
                            ToolbarSpacer(.fixed, placement: .primaryAction)
                            ToolbarItem(placement: .primaryAction) {
                                NavigationLink(destination: Connect()) {
                                    Image(systemName: "hand.wave")
                                        .symbolRenderingMode(.multicolor)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                }
                .background(Color.clear)
            }
            Tab("Rays", systemImage: "sparkles") {
                NavigationStack {
                    Rays()
                    
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    activeSheet = .golden
                                }) {
                                    Image(systemName: "sun.max.fill")
                                        .symbolRenderingMode(.multicolor)
                                }
                            }
                            ToolbarSpacer(.fixed, placement: .navigationBarLeading)
                            ToolbarItem(placement: .cancellationAction) {
                                Button(action: {
                                    activeSheet = .timer
                                }) {
                                    ZStack {
                                        CountdownView(fontSize: 20)
                                            .frame(width: 115)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                            
                            ToolbarItem(placement: .primaryAction) {
                                Button(action: {
                                    activeSheet = .activity
                                }) {
                                    Image(systemName: "bell.badge")
                                        .symbolRenderingMode(.multicolor)
                                        .foregroundColor(.primary)
                                }
                            }
                            ToolbarSpacer(.fixed, placement: .primaryAction)
                            ToolbarItem(placement: .primaryAction) {
                                NavigationLink(destination: Connect()) {
                                    Image(systemName: "hand.wave")
                                        .symbolRenderingMode(.multicolor)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    
                }
                .environment(\.colorScheme, .dark)
            }
            
            Tab("Profile", systemImage: "person.fill") {
                NavigationStack {
                    Profile()
                        .ignoresSafeArea()
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button(action: {
                                    activeSheet = .follow
                                }) {
                                    Image(systemName: "person.2.fill")
                                        .foregroundColor(.primary)
                                }
                            }
                            
                            ToolbarItem(placement: .primaryAction) {
                                Button(action: {
                                    activeSheet = .profile
                                }) {
                                    Image(systemName: "gear")
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .scrollEdgeEffectStyle(.soft, for: .all)
                }
            }
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                NavigationStack {
                    Search()
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Picker("Filter", selection: $selectedOption) {
                                    ForEach(options, id: \.self) { option in
                                        Text(option)
                                            .font(.title)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .scaleEffect(x: 1.2, y: 1.2)
                                .frame(width: 210)
                            }
                        }
                }
            }
            
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .golden:
                GoldenSheet()
                    .presentationDetents([.fraction(0.3)])
                    .presentationDragIndicator(.hidden)
                
            case .activity:
                Activity()
                    .presentationDetents([.medium, .large])
                
            case .timer:
                TimerPage()
                    .presentationDetents([.fraction(0.3)])
            case .follow:
                FollowersPage()
                    .presentationDetents([.medium, .large])
            case .profile:
                ProfileSheet()
                    .presentationDetents([.large])
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .tint(.primary)
    }
}

#Preview {
    MyTabView()
        .environmentObject(TimeManager())
}
