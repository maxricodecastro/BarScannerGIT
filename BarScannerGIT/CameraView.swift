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
    @Published var showNoProductSheet = false
    @Published var isLoading = false
    
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
        isLoading = true
        
        let trimmedBarcode = barcode.hasPrefix("0") ? String(barcode.dropFirst()) : barcode
        print("Trimmed barcode for API: \(trimmedBarcode)")
        
        Task { @MainActor in
            do {
                let data = try await BottomSheetData.fetch(barcode: trimmedBarcode)
                if data.productTitle.isEmpty {
                    showNoProductSheet = true
                } else {
                    bottomSheetViewModel?.updateData(data)
                    showBottomSheet = true
                }
                productName = "Scan a product"
            } catch {
                showNoProductSheet = true
                print("Error occurred: \(error)")
                productName = "Scan a product"
            }
            isLoading = false
            isScanning = true
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
            
            VStack {
                ProductNameHeader(name: viewModel.productName)
                Spacer()
                ScannerOverlay(viewModel: viewModel)
                Spacer()
                BarcodeFooter(code: viewModel.scannedBarcode)
            }
        }
        .sheet(isPresented: $viewModel.showBottomSheet) {
            BottomSheetView()
                .environmentObject(bottomSheetViewModel)
                .presentationDetents([
                    .fraction(0.25),
                    .fraction(0.8)
                ])
                .presentationBackground(.white)
        }
        .sheet(isPresented: $viewModel.showNoProductSheet) {
            NoProductSheet()
                .presentationDetents([.fraction(0.25)])
                .presentationBackground(.white)
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
    @ObservedObject var viewModel: CameraViewModel
    @State private var showLoader = false
    @State private var loaderRef: LoaderView? = nil
    
    var body: some View {
        Group {
            if showLoader {
                LoaderView { 
                    // Animation completed callback
                    showLoader = false
                }
            } else {
                // Static rectangle using LoaderView's style
                ZStack {
                    // Top Line
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.white)
                        .frame(width: width, height: 10)
                        .offset(y: -height/2 + 5)
                    
                    // Right Line
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.white)
                        .frame(width: 10, height: height)
                        .offset(x: width/2 - 5)
                    
                    // Bottom Line
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.white)
                        .frame(width: width, height: 10)
                        .offset(y: height/2 - 5)
                    
                    // Left Line
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.white)
                        .frame(width: 10, height: height)
                        .offset(x: -width/2 + 5)
                }
                .frame(width: width, height: height)
            }
        }
        .onChange(of: viewModel.isLoading) { wasLoading, isLoading in
            if isLoading {
                showLoader = true
            } else {
                // Just set showLoader to false directly
                showLoader = false
            }
        }
    }
    
    private var width: CGFloat {
        UIScreen.main.bounds.width * 0.6
    }
    
    private var height: CGFloat {
        UIScreen.main.bounds.width * 0.36
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

// Add this preview helper struct
struct CameraViewWithOverlayPreview: View {
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                ProductNameHeader(name: viewModel.productName)
                Spacer()
                ScannerOverlay(viewModel: viewModel)
                Spacer()
                BarcodeFooter(code: viewModel.scannedBarcode)
            }
            .overlay(
                Button("Toggle Loading") {
                    viewModel.isLoading.toggle()
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                .padding(),
                alignment: .bottom
            )
        }
    }
}

// Add this test preview struct
struct CameraViewLoadingTestPreview: View {
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                ProductNameHeader(name: viewModel.productName)
                Spacer()
                ScannerOverlay(viewModel: viewModel)
                Spacer()
                BarcodeFooter(code: viewModel.scannedBarcode)
            }
            .overlay(
                VStack {
//                    // Test button to simulate barcode scan
//                    Button("Simulate Barcode Scan") {
//                        viewModel.handleScannedBarcode("123456789")
//                    }
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(8)
                    
                    // Manual loading toggle for testing
                    /* Button("Toggle Loading") {
                        viewModel.isLoading.toggle()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8) */
                }
                .padding(),
                alignment: .bottom
            )
        }
        .environmentObject(BottomSheetViewModel())
    }
}

#Preview {
    CameraViewLoadingTestPreview()
}

