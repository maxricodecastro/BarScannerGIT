import AVFoundation
import SwiftUI

// MARK: - Camera View Model
final class CameraViewModel: ObservableObject {
    @Published var scannedBarcode = ""
    @Published var productName = "Scan a product"
    @Published var showAlert = false
    @Published var errorMessage = ""
    @Published var isScanning = true
    @Published var showBottomSheet = false
    
    private let barcodeService: BarcodeServiceProtocol
    var bottomSheetViewModel: BottomSheetViewModel?
    
    init(barcodeService: BarcodeServiceProtocol = BarcodeService()) {
        self.barcodeService = barcodeService
        print("CameraViewModel initialized")
    }
    
    func handleScannedBarcode(_ barcode: String) {
        guard isScanning else { return }
        
        print("Original scanned barcode: \(barcode)")
        scannedBarcode = barcode
        isScanning = false
        productName = "Loading..."
        
        // Remove only one leading zero for UPC-A format
        let trimmedBarcode = barcode.hasPrefix("0") ? String(barcode.dropFirst()) : barcode
        print("Trimmed barcode for API: \(trimmedBarcode)")
        
        Task { @MainActor in
            do {
                let data = try await BottomSheetData.fetch(barcode: trimmedBarcode)
                bottomSheetViewModel?.updateData(data)
                showBottomSheet = true
                productName = "Scan a product"
            } catch {
                print("Error occurred: \(error)")
                self.showAlert = true
                self.errorMessage = "Error fetching product: \(error.localizedDescription)"
                self.isScanning = true
                productName = "Scan a product"
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
    @EnvironmentObject var bottomSheetViewModel: BottomSheetViewModel
    
    var body: some View {
        ZStack {
            CameraView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    viewModel.bottomSheetViewModel = bottomSheetViewModel
                }
            
            VStack {
                Spacer()
                ScannerOverlay()
                Text(viewModel.productName)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(.top, 4)
                    .padding(.trailing, UIScreen.main.bounds.width * 0.2) // Aligns with rectangle's left edge
                Spacer()
                if !viewModel.scannedBarcode.isEmpty {
                    BarcodeFooter(code: viewModel.scannedBarcode)
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
        .sheet(isPresented: .init(
            get: { viewModel.showBottomSheet },
            set: { viewModel.showBottomSheet = $0 }
        )) {
            BottomSheetView()
                .environmentObject(bottomSheetViewModel)
                .presentationDetents([
                    .fraction(0.25),
                    .fraction(0.8)
                ])
                .presentationBackground(.white)
                .onDisappear {
                    viewModel.resetScanner()
                }
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
        RoundedRectangle(cornerRadius: 12)
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

