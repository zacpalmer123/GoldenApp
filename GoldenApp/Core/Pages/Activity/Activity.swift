//
//  Activity.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 7/31/25.
//

import SwiftUI

enum ActivityTab {
    case likes, comments, requests
}

struct Activity: View {
    @State private var selectedTab: ActivityTab = .likes
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                
                // Header
                HStack {
                    Text("Activity")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                // Tab Buttons
                
                HStack(spacing: 20) {
                    tabButton(title: "Likes", tab: .likes)
                    tabButton(title: "Comments", tab: .comments)
                    tabButton(title: "Requests", tab: .requests)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
            
                
                // Display the selected section only
                Group {
                    switch selectedTab {
                    case .likes:
                        ActivityLikes()
                    case .comments:
                        ActivityComments()
                    case .requests:
                        ActivityRequests()
                    }
                }
            }
            .padding(.top, 20)
        }
        .scrollIndicators(.hidden)
    }
    
    // MARK: - Tab Button Builder
    private func tabButton(title: String, tab: ActivityTab) -> some View {
        Button(action: {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        }) {
            Text(title)
                .font(.system(size: selectedTab == tab ? 25 : 20, weight: .bold, design: .rounded))
                .foregroundColor(selectedTab == tab ? .primary : .gray)
        }
    }
}

#Preview {
    Activity()
}
