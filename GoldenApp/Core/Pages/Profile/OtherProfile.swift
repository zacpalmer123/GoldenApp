//
//  Profile.swift
//  GoldenApp
//
//  Created by Zachary Palmer on 7/31/25.
//

import SwiftUI
import PhotosUI
import AVKit
import UniformTypeIdentifiers
struct OtherTappablePostImage: View {
    var imageName: String

    var body: some View {
        NavigationLink(destination: ViewUserPost()) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}
struct OtherComment: Identifiable {
    let id = UUID()
    let date: String
    let name: String
    let message: String
}
struct OtherGlassCardView: View {
    let comment: Comment

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.2))
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            VStack(alignment: .leading, spacing: 6) {
                Text(comment.date)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(comment.name)
                    .bold()

                Text(comment.message)
                    .font(.caption)
                    .lineLimit(2)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 100)
    }
}

struct OtherProfileCommentsView: View {
    let comments: [Comment] = [
        Comment(date: "June 16, 2025", name: "Jack Malo", message: "You really got a good shot."),
        Comment(date: "June 17, 2025", name: "Sarah Green", message: "Love the colors in this one."),
        Comment(date: "June 18, 2025", name: "Liam Stone", message: "Amazing perspective."),
        Comment(date: "June 19, 2025", name: "Emily Tran", message: "Where was this taken?"),
    ]
    
    var body: some View {
        GeometryReader { geo in
            let screenWidth = geo.size.width
            let cardWidth = screenWidth * 0.7
            let spacing: CGFloat = 16

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(comments) { comment in
                        GlassCardView(comment: comment)
                            .frame(width: cardWidth)
                    }
                }
                .padding(.horizontal, 20)
                .scrollTargetLayout() // iOS 17+
            }
            .frame(height: 140)
            .scrollTargetBehavior(.viewAligned) // 👈 Enables snapping like pages
        }
        .frame(height: 160)
    }
}
struct OtherPostGridView: View {
    let images = [
        "post1.4", "post1.5", "post1",
        "post2", "post2.2", "post1.3"
        
    ]

    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)

    var body: some View {
        NavigationLink(destination: ViewUserPost()) {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(images, id: \.self) { imageName in
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 230)
                        .clipped()
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
struct OtherHorizontalPagingImageScroll: View {
    let images: [String]
    
    private let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    private let timesOfDay = ["06:55", "07:03", "07:12", "06:32", "07:41", "07:50", "07:14"]

    var body: some View {
        
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let spacing: CGFloat = 12
            let visibleImages: CGFloat = 3
            let totalSpacing = spacing * (visibleImages - 1)
            let imageSize = (screenWidth - totalSpacing) / visibleImages

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(Array(images.enumerated()), id: \.1) { index, imageName in
                        NavigationLink(destination: ViewUserPost()) {
                            VStack(alignment: .leading, spacing: 4) {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageSize, height: imageSize + 30)
                                    .clipped()
                                    .cornerRadius(10)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(daysOfWeek[index % daysOfWeek.count])
                                        .font(.caption)
                                        .bold()
                                        .foregroundStyle(.primary)

                                    Text(timesOfDay[index % timesOfDay.count])
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.leading, 4)

                                Spacer()
                            }
                        }
                        .buttonStyle(.plain) // Removes NavigationLink highlight effect
                    }
                }
                .padding(.horizontal, 20)
                
            }
            .frame(height: imageSize + 40)
            
        }
        .frame(height: 155)
    }
}
struct OtherProfileInformation: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
        ZStack{
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(height: 200)
            
        }
    }
}
struct OtherProfile: View {
    @State private var follow = false
    @State private var isLiked = false
    @State var showActivitySheet: Bool = false
    @State private var animateBounce = false
    @State private var offset: CGFloat = 0
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var selectedVideoURL: URL? = nil
    @State private var isChecked = false
    
    @State var showProfileSheet: Bool = false
    @State private var isVerified = true
    @State private var videoDurationTooLong: Bool = false
    private func handleLikeAnimation() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0)) {
            animateBounce = true
            isLiked.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            animateBounce = false
        }
    }

    var body: some View {
      
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    GeometryReader { geometry in
                        let offset = geometry.frame(in: .global).minY
                        ZStack(alignment: .top) {
                            
                          
                                Image("post1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width, height: 400 + (offset > 0 ? offset : 0))
                                    .clipped()
                                    .offset(y: offset > 0 ? -offset : 0)
                            
                            
                            VStack {
                                Spacer()
                                HStack(alignment: .center) {
                                    Text("Zachary Palmer")
                                        .padding(.vertical)
                                        .foregroundColor(.white)
                                        .font(.system(size: 34, weight: .bold))
                                        .shadow(
                                            color: Color.black.opacity(0.9), /// shadow color
                                            radius: 6, /// shadow radius
                                            x: 0, /// x offset
                                            y: 0 /// y offset
                                        )
                                    
                                    Spacer()
                                    
                                
                                    Button(action: {
                                                isChecked.toggle()
                                            }) {
                                                ZStack {
                                                    Circle()
                                                        .fill(isChecked ? Color.blue : Color.green)
                                                        .frame(width: 50, height: 50)
                                                    
                                                    Image(systemName: isChecked ? "sparkles" : "person.fill")
                                                        .font(.title2)
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle()) // optional: removes default button animation
                                    
                                    
                                }
                                .offset(y: offset > 0 ? -offset : 0)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 10)
                            }
                        }
                    }
                    .frame(height: 400) // Fixed height for header
                    
                    // ✅ Insert FunGridView below header
                    VStack(spacing:0){
                        //                            ZStack{
                        //                                AnimatedMeshGradient()
                        //                                    .frame(width: 150, height: 150)
                        //                                    .clipShape(RoundedRectangle(cornerRadius: 20)) // ✅ visually clips corners
                        //
                        //                                   // .padding(.top, 20)
                        //                                Text("Streak\n56")
                        //                                    .font(.system(size: 28, weight: .bold))
                        //                            }
                        //                            .padding(.top, 20)
                        
                        HStack(alignment: .center){
                            VStack(alignment: .leading){
                                Text("This Week")
                                    .font(.system(size: 28, weight: .bold))
                                    .padding(.top, 20)
                                Text("Current Streak: 44")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            
                                            Image(systemName:  "calendar")
                                                .font(.title)
                                                
                                                .foregroundStyle(.primary)
                                                
                                                
                                       
                            .padding(.top, 20)
                        }
                        .padding(.bottom, 35)
                        .padding(.horizontal, 20)
                        HorizontalPagingImageScroll(images: [
                            "post1.4", "post1", "post1.3", "post2", "post2.2"
                        ])
                        
                        .padding(.bottom, 5)
                        
                        HStack{
                            VStack(alignment: .leading){
                                Text("Favorites")
                                    .font(.system(size: 28, weight: .bold))
                                    .padding(.top, 20)
                                Text("Some of my best work")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            ZStack {
                                
                                Image(systemName:"star.fill")
                                    .font(.title2)
                                    .symbolRenderingMode(.multicolor)
                                    
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 20)
                        }
                        .padding(.bottom, 20)
                        .padding(.top, 15)
                        .padding(.horizontal, 20)
                        PostGridView()
                        ProfileCommentsView()
                            .padding(.top)
                            .padding(.bottom, 10)
                    }
                }
            }
            
            .ignoresSafeArea(edges: .top)
            .scrollIndicators(.hidden)
            
            .onChange(of: selectedItem) { newItem in
                guard let item = newItem else { return }

                Task {
                    do {
                        if let videoURL = try await item.loadTransferable(type: URL.self) {
                            let asset = AVAsset(url: videoURL)
                            let duration = CMTimeGetSeconds(asset.duration)

                            print("🎥 Video selected. Duration: \(duration) seconds")

                            if duration <= 15.0 {
                                selectedVideoURL = videoURL
                                selectedImage = nil
                                videoDurationTooLong = false
                            } else {
                                selectedVideoURL = nil
                                selectedImage = nil
                                videoDurationTooLong = true
                                print("⚠️ Video is too long")
                            }

                            return
                        }

                        // If it's not a video, try loading as image
                        if let imageData = try await item.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: imageData) {
                            selectedImage = uiImage
                            selectedVideoURL = nil
                            videoDurationTooLong = false
                            print("🖼️ Loaded image")
                        } else {
                            print("❌ Failed to load image data")
                        }

                    } catch {
                        print("❌ Error loading item: \(error.localizedDescription)")
                    }
                }
            }
        }
                
                .scrollEdgeEffectDisabled()
        
                .toolbar{
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            showActivitySheet = true
                        }) {
                            Image(systemName: "person.2.fill")
                                .symbolRenderingMode(.multicolor)
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
                            Image(systemName: "ellipsis")
                                .symbolRenderingMode(.multicolor)
                                .foregroundColor(.primary)
                        }
                        .sheet(isPresented: $showProfileSheet) {
                            ProfileSheet()
                                .presentationDetents([.fraction(0.5)]) // or .height(200)
                                .presentationDragIndicator(.hidden)
                        }
                        
                    }
                }
        }
    
}


#Preview {
    OtherProfile()
}
