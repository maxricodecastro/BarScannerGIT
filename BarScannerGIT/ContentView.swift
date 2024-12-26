import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var isBottomSheetPresented = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content area
            Theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Content area
                ZStack {
                    switch selectedTab {
                    case 0:
                        HomeView(isBottomSheetPresented: $isBottomSheetPresented)
                    case 1:
                        Text("Search")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Theme.background)
                    case 2:
                        CameraViewWithOverlay()
                            .edgesIgnoringSafeArea(.all)
                    case 3:
                        Text("Notifications")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Theme.background)
                    case 4:
                        Text("Profile")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Theme.background)
                    default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Custom Tab Bar
                CustomTabBar(selectedTab: $selectedTab)
            }
            .background(Theme.background)
            
            // Bottom Sheet
            if isBottomSheetPresented {
                ZStack(alignment: .bottom) {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isBottomSheetPresented = false
                        }
                    
                    CustomBottomSheet(isPresented: $isBottomSheetPresented)
                }
            }
        }
        .background(Theme.background)
    }
}

struct HomeView: View {
    @Binding var isBottomSheetPresented: Bool
    
    var body: some View {
        VStack {
            Text("Home Screen")
                .font(.largeTitle)
                .foregroundColor(Theme.text)
                .padding()
            
            Button("Show Bottom Sheet") {
                isBottomSheetPresented = true
            }
            .padding()
            .background(Theme.primary)
            .foregroundColor(Theme.background)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


