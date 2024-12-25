import AVFoundation
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @State private var isAuthorized = false
    
    class Coordinator: NSObject {
        var parent: CameraView
        var captureSession: AVCaptureSession?
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func setupCaptureSession() {
            // Check camera authorization status
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                DispatchQueue.global(qos: .userInitiated).async {
                    self.setupCamera()
                }
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        DispatchQueue.global(qos: .userInitiated).async {
                            self.setupCamera()
                        }
                    }
                }
            default:
                return
            }
        }
        
        private func setupCamera() {
            let captureSession = AVCaptureSession()
            captureSession.beginConfiguration()
            
            guard let backCamera = AVCaptureDevice.default(for: .video) else { return }
            do {
                let input = try AVCaptureDeviceInput(device: backCamera)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch {
                print("Error setting up camera: \(error.localizedDescription)")
                return
            }
            
            captureSession.commitConfiguration()
            self.captureSession = captureSession
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        context.coordinator.setupCaptureSession()
        
        guard let captureSession = context.coordinator.captureSession else {
            return viewController
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        viewController.view.backgroundColor = .black
        
        previewLayer.frame = viewController.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let previewLayer = uiViewController.view.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiViewController.view.bounds
        }
    }
    
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: Coordinator) {
        coordinator.captureSession?.stopRunning()
    }
}

struct CameraViewWithOverlay: View {
    // Configurable parameters
    private let rectangleWidth: CGFloat = UIScreen.main.bounds.width * 0.6
    private let rectangleHeight: CGFloat = UIScreen.main.bounds.width * 0.36
    private let strokeWidth: CGFloat = 6
    private let strokeColor: Color = .white
    
    var body: some View {
        ZStack {
            CameraView()
                .ignoresSafeArea(.all, edges: .top)
            
            Rectangle()
                .stroke(strokeColor, lineWidth: strokeWidth)
                .frame(width: rectangleWidth, height: rectangleHeight)
                .background(Color.clear)
        }
    }
}

