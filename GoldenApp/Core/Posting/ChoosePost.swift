import SwiftUI
import Combine

// MARK: - Keyboard Responder
class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellables: Set<AnyCancellable> = []

    init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }

        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        Publishers.Merge(willShow, willHide)
            .assign(to: \.currentHeight, on: self)
            .store(in: &cancellables)
    }
}

// MARK: - View Extension to Dismiss Keyboard
extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// MARK: - Main View
struct ChoosePost: View {
    @EnvironmentObject var cameraManager: CameraManager
    @EnvironmentObject var timeManager: TimeManager

    @State private var selectedImages: [UIImage] = []
    @State private var currentIndex = 0
    @State private var captionText: String = ""
    @StateObject private var keyboard = KeyboardResponder()
    @State private var isFadingOut = false

    // Base carousel size
    let baseCarouselWidth = UIScreen.main.bounds.width - 30
    let baseCarouselHeight: CGFloat = 490

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // 🔲 Background Image (Blurred)
                    if cameraManager.capturedImages.indices.contains(currentIndex) {
                        Image(uiImage: cameraManager.capturedImages[currentIndex])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .blur(radius: 30)
                            .ignoresSafeArea()
                    }

                    VStack(spacing: 16) {
                        let scaleFactor: CGFloat = keyboard.currentHeight > 0 ? 0.60 : 1.0
                        let carouselWidth = baseCarouselWidth * scaleFactor
                        let carouselHeight = baseCarouselHeight * scaleFactor

                        // 📸 Image Carousel
                        if !cameraManager.capturedImages.isEmpty {
                            TabView(selection: $currentIndex) {
                                ForEach(cameraManager.capturedImages.indices, id: \.self) { index in
                                    let image = cameraManager.capturedImages[index]

                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: carouselWidth, height: carouselHeight)
                                            .clipped()
                                            .cornerRadius(20)
                                            .scaleEffect(currentIndex == index ? 1 : 0.85)
                                            .opacity(currentIndex == index ? 1 : 0.5)
                                            .animation(.easeInOut(duration: 0.3), value: currentIndex)
                                            .onTapGesture {
                                                if selectedImages.contains(image) {
                                                    selectedImages.removeAll { $0 == image }
                                                } else {
                                                    selectedImages.append(image)
                                                }
                                            }

                                        // ✅ Show trash icon if selected
                                        if selectedImages.contains(image) {
                                            Image(systemName: "photo.on.rectangle.angled")
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(Color.blue)
                                                .clipShape(Circle())
                                                .offset(x: -15, y: 15)
                                        }
                                    }
                                    .tag(index)
                                }
                            }
                            .frame(width: carouselWidth, height: carouselHeight)
                            .tabViewStyle(.page(indexDisplayMode: .never))

                            // 🔘 Pagination Dots
                            HStack(spacing: 4) {
                                ForEach(cameraManager.capturedImages.indices, id: \.self) { index in
                                    Circle()
                                        .fill(index == currentIndex ? Color.primary : Color.secondary.opacity(0.3))
                                        .frame(width: 6, height: 6)
                                }
                            }
                        } else {
                            Spacer()
                            Text("No images captured yet.")
                                .foregroundColor(.secondary)
                            Spacer()
                        }

                        // 📝 Caption TextField
                        ZStack {
                            Rectangle()
                                .frame(height: 50)
                                .cornerRadius(50)
                                .foregroundStyle(Color.clear)
                                .glassEffect()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.leading, 50)

                            HStack {
                                Image("profile1")
                                    .resizable()
                                    .frame(width: 42, height: 42)
                                    .cornerRadius(21)

                                TextField("Write a caption...", text: $captionText)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 10)

                                Spacer()

                                if captionText.isEmpty {
                                    Image(systemName: "mic.fill")
                                        .padding(.trailing, 16)
                                        .transition(.opacity)
                                } else {
                                    Button(action: {
                                        print("Sent caption: \(captionText)")
                                        captionText = ""
                                    }) {
                                        ZStack{
                                            Rectangle()
                                                .frame(width:50, height: 42)
                                                .cornerRadius(50)
                                                .foregroundStyle(Color.blue)
                                            Image(systemName: "paperplane.fill")
                                                .rotationEffect(.degrees(45))
                                                .padding(.trailing, 16)
                                                .foregroundStyle(Color.white)
                                        }
                                    }
                                    .transition(.opacity)
                                }
                            }
                            .padding(.horizontal, 3)
                            .animation(.easeInOut(duration: 0.2), value: captionText)
                        }

                        Spacer()

                        // 🧰 Action Buttons
                        if !cameraManager.capturedImages.isEmpty {
                            HStack {
                                // ✅ Trash button for selected images
                                Button {
                                    withAnimation {
                                        for image in selectedImages {
                                            if let index = cameraManager.capturedImages.firstIndex(of: image) {
                                                cameraManager.capturedImages.remove(at: index)
                                            }
                                        }
                                        selectedImages.removeAll()
                                        if currentIndex >= cameraManager.capturedImages.count {
                                            currentIndex = max(cameraManager.capturedImages.count - 1, 0)
                                        }
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                        .symbolRenderingMode(.hierarchical)
                                        .padding()
                                        .glassEffect(.regular.tint(.clear.opacity(0.4)))
                                        .foregroundStyle(.white)
                                }

                                Button {
                                    // Archive logic
                                } label: {
                                    Text("Favorite")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .glassEffect(.regular.tint(.clear.opacity(0.4)))
                                }

                                Spacer()

                                Button {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        isFadingOut = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        timeManager.showCameraView = false
                                    }
                                } label: {
                                    ZStack{
                                        Rectangle()
                                            .cornerRadius(50)
                                        Text("Post")
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, keyboard.currentHeight + 60)
                    .animation(.easeOut(duration: 0.25), value: keyboard.currentHeight)
                }
                .hideKeyboardOnTap()
            }
            .navigationTitle("Studio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundStyle(.primary)
                }
            }
        }
        .opacity(isFadingOut ? 0 : 1)
    }
}

// MARK: - Preview
#Preview {
    let mockCameraManager = CameraManager()
    let mockTimeManager = TimeManager()

    let sampleImageNames = ["post1.5", "post1.4", "post1", "post2"]
    for name in sampleImageNames {
        if let image = UIImage(named: name) {
            mockCameraManager.capturedImages.append(image)
        }
    }

    return ChoosePost()
        .environmentObject(mockCameraManager)
        .environmentObject(mockTimeManager)
}
