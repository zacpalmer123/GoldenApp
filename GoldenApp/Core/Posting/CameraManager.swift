import AVFoundation
import SwiftUI
import Combine
enum RearCameraType: String, CaseIterable {
    case ultraWide = ".5x"
    case wide = "1x"
    case telephoto = "2x/3x"

    var deviceType: AVCaptureDevice.DeviceType {
        switch self {
        case .ultraWide: return .builtInUltraWideCamera
        case .wide: return .builtInWideAngleCamera
        case .telephoto: return .builtInTelephotoCamera
        }
    }

    var displayLabel: String {
        return self.rawValue
    }
}

class CameraManager: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    @Published var capturedImages: [UIImage] = []

    private let photoOutput = AVCapturePhotoOutput()
    private let videoOutput = AVCaptureVideoDataOutput()

    private var rearCameras: [RearCameraType: AVCaptureDevice] = [:]

    override init() {
        super.init()
        discoverRearCameras()
        configureSession(for: .wide) // Default to wide
    }

    private func discoverRearCameras() {
        let allTypes: [RearCameraType] = [.ultraWide, .wide, .telephoto]
        for type in allTypes {
            let discovery = AVCaptureDevice.DiscoverySession(
                deviceTypes: [type.deviceType],
                mediaType: .video,
                position: .back
            )
            if let device = discovery.devices.first {
                rearCameras[type] = device
                print("✅ Found camera: \(type.rawValue)")
            }
        }
    }

    func configureSession(for cameraType: RearCameraType) {
        guard let device = rearCameras[cameraType],
              let input = try? AVCaptureDeviceInput(device: device) else {
            print("❌ Cannot configure \(cameraType.rawValue) camera")
            return
        }

        session.beginConfiguration()

        // Remove existing inputs and outputs
        session.inputs.forEach { session.removeInput($0) }
        session.outputs.forEach { session.removeOutput($0) }

        // Use high-quality preset for photos
        session.sessionPreset = .photo

        // Add input
        if session.canAddInput(input) {
            session.addInput(input)
        }

        // ✅ Add photo output
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            photoOutput.isHighResolutionCaptureEnabled = true

            if photoOutput.isDepthDataDeliverySupported {
                photoOutput.isDepthDataDeliveryEnabled = true
                print("✅ Depth data delivery enabled")
            } else {
                print("⚠️ Depth data delivery not supported for this camera type")
            }

        }

        // Optional: Add video output
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)

            if let connection = videoOutput.connection(with: .video),
               connection.isVideoStabilizationSupported {
                connection.preferredVideoStabilizationMode = .cinematic
            }
        }

        session.commitConfiguration()
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.isHighResolutionPhotoEnabled = true
        settings.isAutoStillImageStabilizationEnabled = true
        if photoOutput.isDepthDataDeliveryEnabled {
            settings.isDepthDataDeliveryEnabled = true
        }
        settings.flashMode = .auto
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = CIImage(data: imageData) else {
            return
        }

        // Get depth data if available
        if let depthData = photo.depthData {
            let depthMap = depthData.depthDataMap

            // Convert depth map to image
            let depthCIImage = CIImage(cvPixelBuffer: depthMap)

            // Normalize the depth image to 0-1 range
            let normalizedDepth = depthCIImage
                .applyingFilter("CIColorControls", parameters: [
                    kCIInputContrastKey: 1.0,
                    kCIInputBrightnessKey: 0.0,
                    kCIInputSaturationKey: 0.0
                ])
                .applyingFilter("CIColorClamp", parameters: [
                    "inputMinComponents": CIVector(x: 0, y: 0, z: 0, w: 0),
                    "inputMaxComponents": CIVector(x: 1, y: 1, z: 1, w: 1)
                ])

            // Create blurred background
            let blurredImage = image
                .applyingFilter("CIGaussianBlur", parameters: [kCIInputRadiusKey: 15])

            // Blend sharp foreground with blurred background using depth map as mask
            let composite = CIFilter(name: "CIBlendWithMask", parameters: [
                kCIInputImageKey: image,
                kCIInputBackgroundImageKey: blurredImage,
                kCIInputMaskImageKey: normalizedDepth
            ])?.outputImage

            if let finalCIImage = composite {
                let context = CIContext()
                if let cgImage = context.createCGImage(finalCIImage, from: finalCIImage.extent) {
                    let finalUIImage = UIImage(cgImage: cgImage)

                    DispatchQueue.main.async {
                        self.capturedImages.append(finalUIImage)
                    }
                    return
                }
            }
        }

        // If no depth data or processing failed, just use the original image
        if let finalUIImage = UIImage(data: imageData) {
            DispatchQueue.main.async {
                self.capturedImages.append(finalUIImage)
            }
        }
    }

    func startSession() {
        DispatchQueue.global(qos: .background).async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    func switchToFrontOrBackCamera(useFrontCamera: Bool) {
        session.beginConfiguration()

        // Remove current inputs
        session.inputs.forEach { session.removeInput($0) }

        // Choose correct device
        let position: AVCaptureDevice.Position = useFrontCamera ? .front : .back
        let discovery = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: position
        )

        guard let device = discovery.devices.first,
              let input = try? AVCaptureDeviceInput(device: device) else {
            print("❌ Could not access \(useFrontCamera ? "front" : "rear") camera")
            session.commitConfiguration()
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        // Keep using the existing outputs
        if session.canAddOutput(photoOutput) && !session.outputs.contains(photoOutput) {
            session.addOutput(photoOutput)
            photoOutput.isHighResolutionCaptureEnabled = true
        }

        if session.canAddOutput(videoOutput) && !session.outputs.contains(videoOutput) {
            session.addOutput(videoOutput)
        }

        session.commitConfiguration()
    }
    func stopSession() {
        DispatchQueue.global(qos: .background).async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    /// Public helper to check what cameras are available
    var availableCameraTypes: [RearCameraType] {
        return Array(rearCameras.keys).sorted { $0.rawValue < $1.rawValue }
    }
}

