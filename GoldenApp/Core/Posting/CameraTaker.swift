import SwiftUI
import AVFoundation


struct CutoutWithPadding: View {
    var horizontalPadding: CGFloat = 0
    var cutoutHeight: CGFloat = 520  // ✅ Set the cutout height directly
    
    var body: some View {
        GeometryReader { geo in
            let rect = geo.frame(in: .local)
            let holeRect = CGRect(
                x: rect.minX + horizontalPadding,
                y: (rect.height - cutoutHeight) / 2,  // ✅ Centered vertically
                width: rect.width - 2 * horizontalPadding,
                height: cutoutHeight
            )

            let outerPath = Path { path in
                path.addRect(rect)
            }
            let holePath = Path { path in
                path.addRoundedRect(in: holeRect, cornerSize: CGSize(width: 30, height: 30))
            }

            outerPath
                .fill(.black, style: FillStyle(eoFill: true))
                .mask(
                    outerPath
                        .subtracting(holePath)
                        .fill(style: FillStyle(eoFill: true))
                )
        }
        .allowsHitTesting(false)
    }
}

struct GridOverlay: View {
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height

            Path { path in
                // Vertical lines
                path.move(to: CGPoint(x: width / 3, y: 0))
                path.addLine(to: CGPoint(x: width / 3, y: height))
                
                path.move(to: CGPoint(x: 2 * width / 3, y: 0))
                path.addLine(to: CGPoint(x: 2 * width / 3, y: height))
                
                // Horizontal lines
                path.move(to: CGPoint(x: 0, y: height / 3))
                path.addLine(to: CGPoint(x: width, y: height / 3))
                
                path.move(to: CGPoint(x: 0, y: 2 * height / 3))
                path.addLine(to: CGPoint(x: width, y: 2 * height / 3))
            }
            .stroke(Color.white.opacity(0.5), lineWidth: 1)
        }
        .allowsHitTesting(false)
    }
}

struct CameraTaker: View {
    @StateObject private var cameraManager = CameraManager()
    @State private var isDone = false
    @State private var usingFrontCamera = false
    @State private var showFlash = false  // 👈 Add flash state
    @State private var selectedType: RearCameraType = .wide
    @State private var isGridOn = false
    @EnvironmentObject var timeManager: TimeManager
    var body: some View {
        NavigationStack {
            
                ZStack {
                    
                    CameraPreviewView(session: cameraManager.session)
                        .frame(maxWidth: .infinity, maxHeight: 520)
                        .clipped()
                        .cornerRadius(30)
                        .foregroundStyle(.black)
                        .padding(.bottom, 80)
                    if isGridOn {
                        GridOverlay()
                            .frame(maxWidth: .infinity, maxHeight: 520)
                            .cornerRadius(30)
                            .padding(.bottom, 80)
                    }
                    
                    Color.white
                        .frame(height: 520)
                        .cornerRadius(30)
                        .opacity(showFlash ? 1 : 0)
                        .animation(.easeOut(duration: 0.2), value: showFlash)
                        .ignoresSafeArea()
                        .padding(.bottom, 80)
                    
                    
                    VStack {
                        
                        TestCamera2(isGridOn: $isGridOn) // 👈 Pass binding
                            .padding(.top, 10)
                        Spacer()
                        
                        // 📷 Bottom buttons (Thumbnail + Shutter + Speed toggle)
                        VStack(spacing: 16) {
                            SpeedToggle(
                                selectedSpeed: $selectedType,
                                availableSpeeds: cameraManager.availableCameraTypes,
                                onSelect: { type in
                                    cameraManager.configureSession(for: type)
                                }
                                
                            )
                            .padding(.bottom, 60)
                            HStack {
                                // 🔲 Invisible spacer to balance the thumbnail
                                Button(action: {
                                    usingFrontCamera.toggle()
                                    cameraManager.switchToFrontOrBackCamera(useFrontCamera: usingFrontCamera)
                                }) {
                                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 26, height: 26)
                                        .foregroundColor(.white)
                                        .frame(width: 52, height: 52)
                                        .glassEffect()
                                }
                                
                                Spacer()
                                
                                // 📸 Shutter button — stays centered
                                Button(action: {
                                    withAnimation(.easeOut(duration: 0.1)) {
                                        showFlash = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation(.easeOut(duration: 0.05)) {
                                            showFlash = false
                                        }
                                    }
                                    cameraManager.capturePhoto()
                                }) {
                                    ZStack {
                                        Circle()
                                            .frame(width: 80, height: 80)
                                            .foregroundColor(.white)
                                            .mask(Circle().stroke(lineWidth: 6))
                                        Circle()
                                            .frame(width: 65, height: 65)
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                Spacer()
                                
                                // 🖼 Most recent thumbnail (on the right)
                                if let lastImage = cameraManager.capturedImages.last {
                                    Button(action: {
                                        isDone = true
                                    }) {
                                        Image(uiImage: lastImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                            .shadow(radius: 4)
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    Circle()
                                        .strokeBorder(Color.gray.opacity(0.4), lineWidth: 2)
                                        .frame(width: 50, height: 50)
                                }
                            }
                            .padding(.horizontal, 40) // Optional margin
                            .padding(.bottom, 20)
                        }
                    }
                }
                .onAppear {
                    cameraManager.startSession()
                }
                .onDisappear {
                    cameraManager.stopSession()
                }
                .navigationDestination(isPresented: $isDone) {
                    ChoosePost()
                        .environmentObject(cameraManager)
                        .preferredColorScheme(.dark)
                }
            }
        }
    
}
