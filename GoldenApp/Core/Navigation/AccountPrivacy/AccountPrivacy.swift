//
//  AccountPrivacy.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/7/25.
//

import SwiftUI

struct AccountPrivacy: View {
    @State private var isOn = true
    var body: some View {
        VStack(spacing: 10){
            Image("profile1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(200)
                .glassEffect()
            Text("Zachary Palmer")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            Text("@zacpalmer1")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .foregroundColor(.primary)
                
            Toggle(isOn: $isOn) {
                HStack {
                    ZStack {
                        // Both icons in the same stack, only one visible at a time
                        Image(systemName: "lock.fill")
                            .opacity(isOn ? 1 : 0)
                        Image(systemName: "lock.open.fill")
                            .opacity(isOn ? 0 : 1)
                    }
                    .frame(width: 20) // Ensure consistent icon width

                    Text("Private account")
                }
            }
            .foregroundColor(.primary)
            .padding()
            .tint(.green)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThinMaterial)
                    .glassEffect()
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .toggleStyle(.switch)
            .padding()
            HStack {
                Text("When your account is public, your profile and posts can be seen by anyone.")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding()
            
            HStack {
                Text("When your account is private, only the followers you approve can see what you share, including your photos, videos, location, and your followers/following list. Certain info like your profile picture and username is visible to everyone on Golden.")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal)
            HStack {
                Text("By default all accounts are public, until changed to private.")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding()
        }
        .padding(.top, 30)
        Spacer()
    }
}

#Preview {
    AccountPrivacy()
}
