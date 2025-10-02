//
//  GoldenSheet.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/5/25.
//

import SwiftUI
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = ((int >> 24) & 0xff, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
        default:
            (a, r, g, b) = (255, 255, 0, 0)
        }

        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
struct GoldenSheet: View {
    var body: some View {
            VStack(spacing: 10) {
                
                Image("goldenpng")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
                    
                    .padding(.bottom, 10)
                Text("Golden Developer")
                    .font(.system(size: 22, weight: .bold))
                Text("Alpha 1.0")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    
                    .padding(.horizontal)
                Spacer()
                Button {
                    print("Report Bug button pressed.")
                } label: {
                    Text("Report Bug")
                        
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "FF8400"))
                        .foregroundColor(.white)
                        .cornerRadius(80)
                    
                }
                .frame(width: 300)
                .padding(.horizontal)

                
            }
            .padding(.top, 20)
        }
}

#Preview {
    GoldenSheet()
}
