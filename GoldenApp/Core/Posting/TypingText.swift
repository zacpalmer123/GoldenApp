//
//  TypingText.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/8/25.
//

import SwiftUI
import Combine
import UIKit

struct TypingText: View {
    let fullText: String
    let typingSpeed: Double
    let cursor: String

    @State private var displayedText: String = ""
    @State private var showCursor: Bool = true
    private let cursorTimer = Timer.publish(every: 0.6, on: .main, in: .common).autoconnect()
    
    // Haptic feedback generator
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        ZStack(alignment: .leading) {
            // Invisible full text to prevent layout shift
            Text(fullText)
                .opacity(0)
                .monospaced()
                .font(.system(size: 50, weight: .bold, design: .rounded))

            // Typing animated text
            Text(displayedText + (showCursor ? cursor : " "))
                .monospaced()
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .animation(nil, value: displayedText)
        }
        .onAppear {
            feedbackGenerator.prepare()
            startTyping()
        }
        .onReceive(cursorTimer) { _ in
            showCursor.toggle()
        }
    }

    private func startTyping() {
        displayedText = ""
        Task {
            for character in fullText {
                displayedText.append(character)

                // Pulse haptic feedback per character
                feedbackGenerator.impactOccurred()

                try? await Task.sleep(nanoseconds: UInt64(typingSpeed * 1_000_000_000))
            }
        }
    }
}
