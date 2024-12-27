import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @StateObject private var cameraViewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case 0:
                HomeView()
            case 1:
                Text("Search")
            case 2:
                CameraView(viewModel: cameraViewModel)
            case 3:
                Text("Notifications")
            case 4:
                Text("Profile")
            default:
                Text("Unknown Tab")
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct HomeView: View {
    @State var showingBottomSheet = false
    var body: some View {
        VStack {
            Button("Tap me") {
                showingBottomSheet.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
        .sheet(isPresented:  $showingBottomSheet) {
            BottomSheetView()
                .presentationDetents([.fraction(0.3), .fraction(0.8)])
        }
    }
}


//content of the sheet
struct BottomSheetView : View {
    var body: some View {
        VStack {
            // Top content that stays fixed
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Product Title")
                        .font(Theme.Typography.title)
                        .foregroundColor(Theme.Typography.titleColor)
                        
                    Text("Subtitle Product")
                        .font(Theme.Typography.subtitle)
                    
                    //review stars
                    HStack(spacing: 4) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.leading, 0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button(action: {
                    // Action here
                }) {
                    Text("$100")
                        .font(Theme.Typography.largeText)
                        .foregroundColor(Theme.Typography.largeTextColor)  // Text color
                        .frame(width: 60, height: 30)  // Button size
                        .background(Color.white)  // Background color
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Theme.Typography.largeTextColor, lineWidth: 2)  // Stroke color and width
                        )
                        .cornerRadius(10)
                }
                .padding(.trailing, 16)  // Space from right edge
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 108)
            .padding(.top, 24)
            
            Spacer()  // Pushes everything below down
            
            
            
            // Bottom content
            HStack {
                Image(systemName: "star")
                    .padding()
                
                Image(systemName: "bell")
                    .padding()
                
                Image(systemName: "globe")
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


