import AVFoundation
import SwiftUI

// MARK: - Camera View Model
final class CameraViewModel: ObservableObject {
    @Published var scannedBarcode = ""
    @Published var productName = "Scan a product"
    @Published var showAlert = false
    @Published var errorMessage = ""
    @Published var isScanning = true
    
    private let barcodeService: BarcodeServiceProtocol
    
    init(barcodeService: BarcodeServiceProtocol = BarcodeService()) {
        self.barcodeService = barcodeService
        print("CameraViewModel initialized")
    }
    
    func handleScannedBarcode(_ barcode: String) {
        guard isScanning else { return }
        
        print("Handling barcode: \(barcode)")
        scannedBarcode = barcode
        isScanning = false
        
        Task { @MainActor in
            do {
                print("Fetching product info for barcode: \(barcode)")
                let info = try await barcodeService.fetchProductInfo(barcode: barcode)
                
                // Build product name from available information
                let productInfo = [
                    info.brand,
                    info.title,
                    info.description
                ].compactMap { $0 }.joined(separator: " - ")
                
                self.productName = productInfo.isEmpty ? "Product details not found" : productInfo
                print("Updated product name to: \(self.productName)")
            } catch {
                print("Error occurred: \(error)")
                self.showAlert = true
                self.errorMessage = "Error fetching product: \(error.localizedDescription)"
                self.isScanning = true
            }
        }
    }
    
    func resetScanner() {
        isScanning = true
        scannedBarcode = ""
        productName = "Scan a product"
    }
}

// MARK: - Camera View
struct CameraView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CameraViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        context.coordinator.setupCamera(in: viewController)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        context.coordinator.updatePreviewLayer(in: uiViewController)
    }
}

// MARK: - Camera Coordinator
extension CameraView {
    final class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        private let parent: CameraView
        private var captureSession: AVCaptureSession?
        private var previewLayer: AVCaptureVideoPreviewLayer?
        
        init(_ parent: CameraView) {
            self.parent = parent
            super.init()
        }
        
        func setupCamera(in viewController: UIViewController) {
            let session = AVCaptureSession()
            captureSession = session
            
            guard let videoDevice = AVCaptureDevice.default(for: .video),
                  let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
                handleError("Unable to access camera")
                return
            }
            
            guard session.canAddInput(videoInput) else {
                handleError("Unable to add camera input")
                return
            }
            
            session.addInput(videoInput)
            
            let metadataOutput = AVCaptureMetadataOutput()
            guard session.canAddOutput(metadataOutput) else {
                handleError("Unable to add metadata output")
                return
            }
            
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .upce, .code128]
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            self.previewLayer = previewLayer
            previewLayer.frame = viewController.view.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            viewController.view.layer.addSublayer(previewLayer)
            
            DispatchQueue.global(qos: .userInitiated).async {
                session.startRunning()
            }
        }
        
        func updatePreviewLayer(in viewController: UIViewController) {
            previewLayer?.frame = viewController.view.layer.bounds
        }
        
        private func handleError(_ message: String) {
            parent.viewModel.errorMessage = message
            parent.viewModel.showAlert = true
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput,
                           didOutput metadataObjects: [AVMetadataObject],
                           from connection: AVCaptureConnection) {
            guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  let barcodeValue = metadataObject.stringValue else { return }
            
            parent.viewModel.handleScannedBarcode(barcodeValue)
        }
    }
}

// MARK: - Camera View With Overlay
struct CameraViewWithOverlay: View {
    @StateObject private var viewModel = CameraViewModel()
    
    private let scannerOverlay = ScannerOverlay()
    
    var body: some View {
        ZStack {
            CameraView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ProductNameHeader(name: viewModel.productName)
                Spacer()
                scannerOverlay
                Spacer()
                if !viewModel.scannedBarcode.isEmpty {
                    VStack {
                        BarcodeFooter(code: viewModel.scannedBarcode)
                        Button("Scan Again") {
                            viewModel.resetScanner()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .alert("Camera Error", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { 
                viewModel.resetScanner()
            }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

// MARK: - UI Components
private struct ProductNameHeader: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.title2)
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 50)
            .multilineTextAlignment(.center)
            .animation(.easeInOut, value: name)
    }
}

private struct ScannerOverlay: View {
    var body: some View {
        Rectangle()
            .stroke(Color.white, lineWidth: 6)
            .frame(
                width: UIScreen.main.bounds.width * 0.6,
                height: UIScreen.main.bounds.width * 0.36
            )
            .background(Color.clear)
    }
}

private struct BarcodeFooter: View {
    let code: String
    
    var body: some View {
        Text("Barcode: \(code)")
            .font(.title3)
            .padding()
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 50)
    }
}

