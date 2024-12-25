import AVFoundation
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @State private var isAuthorized = false
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    class Coordinator: NSObject {
        var parent: CameraView
        var captureSession: AVCaptureSession?
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func setupCaptureSession() {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                setupCamera()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.setupCamera()
                    } else {
                        self.handleError("Camera access denied")
                    }
                }
            case .denied, .restricted:
                handleError("Camera access denied")
            @unknown default:
                handleError("Unknown camera authorization status")
            }
        }
        
        private func handleError(_ message: String) {
            DispatchQueue.main.async {
                self.parent.errorMessage = message
                self.parent.showAlert = true
            }
        }
        
        private func setupCamera() {
            let session = AVCaptureSession()
            self.captureSession = session
            
            session.beginConfiguration()
            
            guard let videoDevice = AVCaptureDevice.default(for: .video) else {
                handleError("Unable to access camera")
                return
            }
            
            do {
                let videoInput = try AVCaptureDeviceInput(device: videoDevice)
                if session.canAddInput(videoInput) {
                    session.addInput(videoInput)
                }
                
                session.commitConfiguration()
                
                DispatchQueue.global(qos: .userInitiated).async {
                    session.startRunning()
                }
            } catch {
                handleError("Error setting up camera: \(error.localizedDescription)")
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        DispatchQueue.main.async {
            context.coordinator.setupCaptureSession()
            
            if let session = context.coordinator.captureSession {
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.frame = viewController.view.bounds
                viewController.view.layer.addSublayer(previewLayer)
            }
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
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    private let rectangleWidth: CGFloat = UIScreen.main.bounds.width * 0.6
    private let rectangleHeight: CGFloat = UIScreen.main.bounds.width * 0.36
    private let strokeWidth: CGFloat = 6
    private let strokeColor: Color = .white
    
    var body: some View {
        ZStack {
            CameraView()
                .ignoresSafeArea()
                .alert("Camera Error", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(errorMessage)
                }
            
            Rectangle()
                .stroke(strokeColor, lineWidth: strokeWidth)
                .frame(width: rectangleWidth, height: rectangleHeight)
                .background(Color.clear)
        }
    }
}

