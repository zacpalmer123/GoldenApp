//
//  SharePage.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 8/19/25.
//

import SwiftUI
struct AppIcon: Hashable {
    let imageName: String
    let label: String
}

let apps: [AppIcon] = [
    AppIcon(imageName: "Messages", label: "Messages"),
    AppIcon(imageName: "Snapchat", label: "Snapchat"),
    AppIcon(imageName: "X", label: "X"),
    AppIcon(imageName: "Insta", label: "Instagram")
]
struct SharePage: View {
    
    var body: some View {
        
        VStack(spacing:25){
            HStack(spacing:25){
                Image("post1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .cornerRadius(20)
                VStack(alignment: .leading, spacing: 3){
                    Text("Zachary Palmer")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    Text("August 19 2025")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text("Golden")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                Spacer()
                ZStack{
                    FullScreenAnimatedMeshGradient()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.orange)
                    Image(systemName: "arrow.down.circle.dotted")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.top, 25)
            .padding(.horizontal, 25)
            Divider()
                .padding(.horizontal, 25)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 20) {
                    ForEach(0..<10) { _ in // Replace 10 with the actual number of items or a data array
                        VStack() {
                            ZStack{
                                Image("profile1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(200)
                                    
                                Image("logogolden")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .cornerRadius(4)
                                    .offset(x:25, y: 25)
                            }
                            Text("Zachary \n Palmer")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 25)
            Divider()
                .padding(.horizontal, 25)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 25) {
                    ForEach(apps, id: \.self) { app in
                        VStack {
                            Image(app.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .cornerRadius(20) // optional styling
                            Text(app.label)
                                .font(.caption)
                                
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 25)
            }
        }
        
        Spacer()
    }
}

#Preview {
    SharePage()
}
