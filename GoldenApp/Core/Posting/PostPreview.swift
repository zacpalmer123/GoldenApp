import SwiftUI

struct PostPreviewImages: View {
    let images: [UIImage]
    @State private var currentIndex = 0
    @State private var inputCaption = ""
    @State private var showFinishPost = false


    var body: some View {
        
        VStack(spacing: 10) {
            Spacer()
            Spacer()
            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 520)
                        .cornerRadius(20)
                        .clipped()
                        .tag(index)
                }
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 520)
            
            HStack(spacing: 4) {
                ForEach(images.indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.primary : Color.secondary.opacity(0.3))
                        .frame(width: 6, height: 6)
                }
            }
            HStack(spacing: 10){
                
                Image("profile1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(200)
                    .glassEffect()
                VStack(alignment: .leading, spacing: 4){
                    Text("Zachary Palmer")
                        .font(.subheadline).bold()
                    TextField("Write a caption", text: $inputCaption)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                Spacer()
                
                
            }
            .padding(.horizontal, 20)
            // ... Profile + Post button as needed ...
            Spacer()
            HStack{
                ZStack{
                    Rectangle()
                        .frame(width: 120, height: 50)
                        .foregroundStyle(.gray)
                        .cornerRadius(200)
                    Text("Archive")
                    
                        .foregroundStyle(.white)
                        .font(.system(size:20, weight: .bold, design: .rounded))
                }
                .padding(.bottom, 10)
                Button(action: {
                    showFinishPost = true
                }) {
                    ZStack {
                        Rectangle()
                            .frame(width: 120, height: 50)
                            .foregroundStyle(.primary)
                            .cornerRadius(200)
                        
                        Text("Post")
                            .foregroundStyle(.white)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .padding(.bottom, 10)
                    
                }
                
            }
            Spacer()
            
        }
        .fullScreenCover(isPresented: $showFinishPost) {
            FinishPost()
            
        }
        .ignoresSafeArea(.all)
    }
}
#Preview {
    let sampleImages = [
        UIImage(named: "post1")!,
        UIImage(named: "post1.2")!,
        UIImage(named: "post1.3")!
    ]
    
    return PostPreviewImages(images: sampleImages)
}

