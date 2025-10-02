//
//  FollowersPage.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 10/1/25.
//

import SwiftUI
enum FollowTab {
    case followers, following
}
struct FollowersPage: View {
    @State private var selectedTab: FollowTab = .followers
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                
                
                // Tab Buttons
                
                HStack(spacing: 20) {
                    tabButton(title: "Followers", tab: .followers)
                    tabButton(title: "Following", tab: .following)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
            
                
                // Display the selected section only
                Group {
                    switch selectedTab {
                    case .followers:
                        Followers()
                    case .following:
                        Following()
                    
                    }
                }
            }
            .padding(.top, 20)
        }
        .scrollIndicators(.hidden)
    }
    
    // MARK: - Tab Button Builder
    private func tabButton(title: String, tab: FollowTab) -> some View {
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
    FollowersPage()
}
