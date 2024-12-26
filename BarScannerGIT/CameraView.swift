import AVFoundation
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @Binding var scannedBarcode: String
    @Binding var showAlert: Bool
    @Binding var errorMessage: String
    @Binding var productName: String
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: CameraView
        var captureSession: AVCaptureSession?
        var previewLayer: AVCaptureVideoPreviewLayer?
        
        init(_ parent: CameraView) {
            self.parent = parent
            super.init()
            setupCamera()
        }
        
        func setupCamera() {
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
                
                let metadataOutput = AVCaptureMetadataOutput()
                if session.canAddOutput(metadataOutput) {
                    session.addOutput(metadataOutput)
                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [.ean8, .ean13, .upce, .code128]
                }
                
                session.commitConfiguration()
                
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                self.previewLayer = previewLayer
                previewLayer.videoGravity = .resizeAspectFill
                
                DispatchQueue.global(qos: .userInitiated).async {
                    session.startRunning()
                }
            } catch {
                handleError("Error setting up camera: \(error.localizedDescription)")
            }
        }
        
        private func handleError(_ message: String) {
            DispatchQueue.main.async {
                self.parent.errorMessage = message
                self.parent.showAlert = true
            }
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput,
                           didOutput metadataObjects: [AVMetadataObject],
                           from connection: AVCaptureConnection) {
            guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  let barcodeValue = metadataObject.stringValue else {
                return
            }
            
            DispatchQueue.main.async {
                self.parent.scannedBarcode = barcodeValue
                // Optional: Stop scanning after successful detection
                // self.captureSession?.stopRunning()
            }
        }
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        if let previewLayer = context.coordinator.previewLayer {
            previewLayer.frame = viewController.view.layer.bounds
            viewController.view.layer.addSublayer(previewLayer)
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        context.coordinator.previewLayer?.frame = uiViewController.view.layer.bounds
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

struct CameraViewWithOverlay: View {
    @State private var showAlert = false
    @State private var errorMessage = ""
    @State private var scannedBarcode = ""
    @State private var productName: String = "Product Name"
    
    private let rectangleWidth: CGFloat = UIScreen.main.bounds.width * 0.6
    private let rectangleHeight: CGFloat = UIScreen.main.bounds.width * 0.36
    private let strokeWidth: CGFloat = 6
    private let strokeColor: Color = .white
    
    var body: some View {
        ZStack {
            VStack {
                Text(productName)
                    .font(.title)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 50)
                
                Spacer()
            }
            .zIndex(1)
            
            CameraView(scannedBarcode: $scannedBarcode,
                      showAlert: $showAlert,
                      errorMessage: $errorMessage,
                      productName: $productName)
                .edgesIgnoringSafeArea(.all)
            
            Rectangle()
                .stroke(strokeColor, lineWidth: strokeWidth)
                .frame(width: rectangleWidth, height: rectangleHeight)
                .background(Color.clear)
            
            if !scannedBarcode.isEmpty {
                Text("Barcode: \(scannedBarcode)")
                    .font(.title)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .alert("Camera Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

