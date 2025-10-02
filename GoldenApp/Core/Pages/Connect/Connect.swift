//
//  Connect.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 7/31/25.
//

import SwiftUI

struct Connect: View {
    @EnvironmentObject var timeManager: TimeManager
    @State var showActivitySheet: Bool = false
    @State var showProfileSheet: Bool = false
    @State var showTimerSheet: Bool = false
    @State private var showCountdown = false
    var body: some View {
        ZStack{
            if timeManager.isInGoldenHour {
                AnimatedMeshGradient()
                    .opacity(0.6)
                    .transition(.opacity)
                    .offset(y: -200)
            }
            ScrollView{
                LazyVStack{
                    
                    ForEach(0..<20, id: \.self){ _ in
                        MessagePreview()
                            .padding(.bottom, 25)
                    }
                    
                }
                .padding(.top, 20)
            }
            .toolbar{
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
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                    }
                    .sheet(isPresented: $showActivitySheet) {
                        Activity()
                            .presentationDetents([.medium, .large]) // or .height(200)
                        
                    }
                    
                }
               
                
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showProfileSheet = true
                    }) {
                        Image(systemName: "square.and.pencil")
                        
                            .foregroundColor(.primary)
                    }
                    .sheet(isPresented: $showProfileSheet) {
                        ProfileSheet()
                            .presentationDetents([.fraction(0.5)]) // or .height(200)
                            .presentationDragIndicator(.hidden)
                    }
                    
                }
                
            
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    Connect()
}
