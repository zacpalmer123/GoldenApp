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

struct MyTabView: View {
    @State var showGoldenSheet: Bool = false
    @State var showActivitySheet: Bool = false
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
                                        showGoldenSheet = true
                                    }) {
                                        Image(systemName: "sun.max.fill")
                                            .symbolRenderingMode(.multicolor)
                                        
                                    }
                                    .sheet(isPresented: $showGoldenSheet) {
                                        GoldenSheet()
                                            .presentationDetents([.fraction(0.3)]) // or .height(200)
                                            .presentationDragIndicator(.hidden)
                                    }
                                    
                                }
                                
                                ToolbarSpacer(.fixed, placement: .navigationBarLeading)
                                
                                ToolbarItem(placement: .cancellationAction) {
                                    Button(action: {
                                        showTimerSheet = true
                                    }) {
                                        ZStack{
                                            CountdownView(fontSize: 20)
                                                .frame(width: 115)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                    
                                    .sheet(isPresented: $showTimerSheet) {
                                        
                                        TimerPage()
                                            .presentationDetents([.fraction(0.3)])
                                        //                                                                        CameraTaker()
                                        //                                                                            .presentationDetents([.large])
                                        
                                    }
                                    .onAppear {
                                        // Delay before switching to CountdownView
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                            withAnimation(.easeInOut(duration: 1.0)) {
                                                showCountdown = true
                                            }
                                        }
                                    }
                                }
                                
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: {
                                        showActivitySheet = true
                                    }) {
                                        Image(systemName: "bell.badge")
                                            .symbolRenderingMode(.multicolor)
                                            .foregroundColor(.primary)
                                    }
                                    .sheet(isPresented: $showActivitySheet) {
                                        Activity()
                                            .presentationDetents([.medium, .large]) // or .height(200)
                                        
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
                                        showGoldenSheet = true
                                    }) {
                                        Image(systemName: "sun.max.fill")
                                            .symbolRenderingMode(.multicolor)
                                        
                                    }
                                    .sheet(isPresented: $showGoldenSheet) {
                                        GoldenSheet()
                                            .presentationDetents([.fraction(0.3)]) // or .height(200)
                                            .presentationDragIndicator(.hidden)
                                    }
                                    
                                }
                                
                                ToolbarSpacer(.fixed, placement: .navigationBarLeading)
                                
                                ToolbarItem(placement: .cancellationAction) {
                                    Button(action: {
                                        showTimerSheet = true
                                    }) {
                                        ZStack{
                                            CountdownView(fontSize: 20)
                                                .frame(width: 115)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                    
                                    .sheet(isPresented: $showTimerSheet) {
                                        
                                        TimerPage()
                                            .presentationDetents([.fraction(0.3)])
                                        //                                                                        CameraTaker()
                                        //                                                                            .presentationDetents([.large])
                                        
                                    }
                                    .onAppear {
                                        // Delay before switching to CountdownView
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                            withAnimation(.easeInOut(duration: 1.0)) {
                                                showCountdown = true
                                            }
                                        }
                                    }
                                }
                                
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: {
                                        showActivitySheet = true
                                    }) {
                                        Image(systemName: "bell.badge")
                                            .symbolRenderingMode(.multicolor)
                                            .foregroundColor(.primary)
                                    }
                                    .sheet(isPresented: $showActivitySheet) {
                                        Activity()
                                            .presentationDetents([.medium, .large]) // or .height(200)
                                        
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
                }
                
                Tab("Profile", systemImage: "person.fill") {
                    NavigationStack {
                        Profile()
                            .ignoresSafeArea()
                        
                            .toolbar {
                                
                                
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: {
                                        showActivitySheet = true
                                    }) {
                                        Image(systemName: "person.2.fill")
                                            .foregroundColor(.primary)
                                    }
                                    .sheet(isPresented: $showActivitySheet) {
                                        FollowersPage()
                                            .presentationDetents([.medium, .large]) // or .height(200)
                                        
                                    }
                                    
                                }
                               
                                
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: {
                                        showProfileSheet = true
                                    }) {
                                        Image(systemName: "gear")
                                        
                                            .foregroundColor(.primary)
                                    }
                                    .sheet(isPresented: $showProfileSheet) {
                                        ProfileSheet()
                                            .presentationDetents([.large]) // or .height(200)
                                            .presentationDragIndicator(.hidden)
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
                                                            .pickerStyle(.segmented) // ✅ makes it segmented like Apple Music
                                                            
                                                           
                                                            .scaleEffect(x: 1.2, y: 1.2)
                                                            
                                                            .frame(width: 210)        // optional: control width
//                                                            .padding()
//                                                            .glassEffect()
                                                        }
                            }
                    }
                }
                
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .tint(.orange)
        
    }
}

#Preview {
    MyTabView()
        .environmentObject(TimeManager())
}
