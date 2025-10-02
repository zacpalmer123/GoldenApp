import SwiftUI

struct TestCarousel: View {
    let images = ["post1", "post1.2", "post1.3"]
    @State private var currentIndex = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if images.indices.contains(currentIndex) {
                    Image(images[currentIndex])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: .infinity)
                        .blur(radius: 30)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                        .ignoresSafeArea(edges: .all)
                }
                VStack{
                    Spacer()
                    TabView(selection: $currentIndex) {
                                            ForEach(images.indices, id: \.self) { index in
                                                Image(images[index])
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: UIScreen.main.bounds.width - 30, height: 490)
                                                    .clipped()
                                                    .cornerRadius(20)
                                                    .scaleEffect(currentIndex == index ? 1 : 0.85)
                                                    .opacity(currentIndex == index ? 1 : 0.5)
                                                    .tag(index)
                                            }
                                        }
                                        .frame(height: 500)
                                        .tabViewStyle(.page(indexDisplayMode: .never))
                                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                    HStack(spacing: 4) {
                        ForEach(images.indices, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color.primary : Color.secondary.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }
                    }
                    ZStack{
                        Rectangle()
                            .frame(height: 50)
                            .cornerRadius(50)
                            .foregroundStyle(Color.clear)
                            .glassEffect()
                        HStack{
                            Image("profile1")
                                .resizable()
                                .frame(width: 42, height: 42)
                                .cornerRadius(22.5)
                            Text("Write a caption...")
                            Spacer()
                            Image(systemName:"microphone")
                                .padding(.trailing, 16)
                        }
                        .padding(.horizontal, 3)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    Spacer()
                    HStack {
                                            Button {
                                                print("Delete tapped")
                                            } label: {
                                                Image(systemName: "trash")
                                                    .symbolRenderingMode(.hierarchical)
                                                    .padding()
                                                    .glassEffect(.regular.tint(.clear.opacity(0.6)))
                                                    .foregroundStyle(.white)
                                            }
                    
                                            Button {
                                                print("Archive tapped")
                                            } label: {
                                                Text("Archive")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .glassEffect(.regular.tint(.clear.opacity(0.4)))
                                            }
                                            Spacer()
                    
                                            Button {
                                                print("Post tapped")
                                            } label: {
                                                Text("Post")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .glassEffect(.regular.tint(.blue.opacity(0.8)))
                                            }
                                        }
                    .padding(.horizontal, 20)
                    
                }
                

         }
      }
    }
}

#Preview {
    TestCarousel()
}
