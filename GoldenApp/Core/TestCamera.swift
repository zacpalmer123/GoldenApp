//
//  TestCamera.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 9/3/25.
//

import SwiftUI

struct TestCamera2: View {
    @Binding var isGridOn: Bool
    @State private var selectedTimer: String? = nil
    @State private var isFlashOn = false
    @State private var showTimerOptions = false

    let timerOptions = ["30sec", "1min", "3min"]

    var body: some View {
        HStack {
            HStack {
                Button(action: {
                    withAnimation(.easeInOut) {
                        showTimerOptions.toggle()
                        if !showTimerOptions {
                            selectedTimer = nil
                        }
                    }
                }) {
                    Image(systemName: "timer")
                        .foregroundColor(showTimerOptions ? .yellow : .white)
                        .frame(width: 20, height: 50)
                }

                if showTimerOptions {
                    HStack(spacing: 15) {
                        ForEach(timerOptions, id: \.self) { option in
                            Button(action: {
                                selectedTimer = option
                            }) {
                                Text(option)
                                    .foregroundColor(selectedTimer == option ? .yellow : .white)
                                    .animation(nil, value: selectedTimer)
                            }
                        }
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .frame(height: 50)
            .padding(.horizontal)
            .glassEffect()

            Spacer()

            // 📐 Grid toggle
            Button(action: {
                isGridOn.toggle()
            }) {
                Image(systemName: "grid")
                    .foregroundColor(isGridOn ? .yellow : .white)
                    .frame(width: 50, height: 50)
                    .glassEffect()
            }

            // ⚡ Flash toggle
            Button(action: {
                isFlashOn.toggle()
            }) {
                Image(systemName: isFlashOn ? "bolt.fill" : "bolt")
                    .foregroundColor(isFlashOn ? .yellow : .white)
                    .frame(width: 50, height: 50)
                    .glassEffect()
            }
        }
        .padding(.horizontal, 20)
    }
}


