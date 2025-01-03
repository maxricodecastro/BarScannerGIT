import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var showingBottomSheet = false
    @StateObject private var cameraViewModel = CameraViewModel()
    @StateObject private var bottomSheetViewModel = BottomSheetViewModel()
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case 0:
                HomePage()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
            case 1:
                Search()
            case 2:
                CameraViewWithOverlay()
                    .environmentObject(bottomSheetViewModel)
                    .sheet(isPresented: $showingBottomSheet) {
                        BottomSheetView()
                            .environmentObject(bottomSheetViewModel)
                            .presentationDetents([
                                .fraction(0.25),
                                .fraction(0.8)
                            ])
                            .presentationBackground(.white)
                    }
            case 3:
                History()
            case 4:
                Text("Profile Tab")
            default:
                Text("Unknown Tab")
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(.keyboard)
            .zIndex(2)
        }
        .background(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



