//
//  ProfileSheet.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/5/25.
//

import SwiftUI

struct ProfileSheet: View {
    @State var showBlockedSheet: Bool = false
    @State var showAccountPrivacySheet: Bool = false
    var body: some View {
        VStack(spacing: 10) {
            
            Image("profile1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(200)
                .glassEffect()
            Text("Zachary Palmer")
                .font(.system(size: 22, weight: .bold, design: .rounded))
            Text("@zacpalmer1")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                
            ZStack{
                
            }
            List{
                Button {
                print("hello")
                } label: {
                    HStack{
                        ZStack{
                            Circle()
                                .frame(width: 30)
                                .foregroundColor(Color.blue.opacity(0.6))
                                .glassEffect()
                            Image(systemName: "bell.fill")
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.8), radius: 10, x: 0, y: 5)
                                .font(.caption)
                        }
                        Text("Notifications")
                            .foregroundColor(.primary)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.primary)
                            .font(.caption)
                    }
                }
                Button {
                    showAccountPrivacySheet = true
                } label: {
                    HStack{
                        ZStack{
                            Circle()
                                .frame(width: 30)
                                .foregroundColor(Color.green.opacity(0.6))
                                .glassEffect()
                            Image(systemName: "lock.fill")
                                .font(.caption)
                                .shadow(color: .black.opacity(0.8), radius: 10, x: 0, y: 5)
                                .foregroundColor(.white)
                                
                        }
                        Text("Account Privacy")
                            .foregroundColor(.primary)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.primary)
                            .font(.caption)
                    }
                    .sheet(isPresented: $showAccountPrivacySheet) {
                        AccountPrivacy()
                            .presentationDetents([.large]) // or .height(200)
                            .presentationDragIndicator(.hidden)
                    }
                }
                Button {
                    showBlockedSheet = true
                } label: {
                    HStack{
                        ZStack{
                            Circle()
                                .frame(width: 30)
                                .foregroundColor(Color.red.opacity(0.6))
                                .glassEffect()
                            Image(systemName: "figure.fall")
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.8), radius: 10, x: 0, y: 5)
                                .font(.caption)
                        }
                        Text("Blocked")
                            .foregroundColor(.primary)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.primary)
                            .font(.caption)
                    }
                    .sheet(isPresented: $showBlockedSheet) {
                        BlockedSheet()
                            .presentationDetents([.large]) // or .height(200)
                            .presentationDragIndicator(.hidden)
                    }
                }
                

            }
            .scrollContentBackground(.hidden)
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        }
        .padding(.top, 20)
    
    }
}

#Preview {
    ProfileSheet()
}
