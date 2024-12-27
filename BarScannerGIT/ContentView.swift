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
            Button(action: {
                showingBottomSheet = true
            }) {
                HStack(spacing: 8) {
                    Text("Button Text")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .cornerRadius(12)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
        .sheet(isPresented: $showingBottomSheet) {
            BottomSheetView()
                .presentationDetents([.fraction(0.3), .fraction(0.8)])
                .presentationBackground(.white)
        }
    }
}


//content of the sheet
struct BottomSheetView : View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Color.clear.frame(height: 2) // Fixed 8px spacing at top
                
                VStack(spacing: 24) {
                    VStack {
                        // Top content that stays fixed
                        HStack(alignment: .top, spacing: 12) {
                            Image(Theme.Images.metaquest3)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 110, height: 126)
                                .background(Color.gray.opacity(0.2))
                                .clipped()
                                .cornerRadius(10)
                                .padding(.leading, -4)
                            
                            //entire vstack
                            VStack(alignment: .leading, spacing: 4) {
                                // Product Title VStack
                                VStack(alignment: .leading, spacing: 4) { // Control spacing between title and subtitle
                                    Text("Meta Quest 3")
                                        .font(Theme.Typography.title)
                                        .foregroundColor(Theme.Typography.titleColor)
                                        .padding(.leading, 0)
                                    
                                    Text("Meta")
                                        .font(Theme.Typography.largeText)
                                        .foregroundColor(Theme.Typography.largeTextColor)
                                        .padding(.leading, 0)
                                }
                                .padding(.top, 8) // Control space from top of parent VStack
                                
                                //review stars
                                HStack(spacing: 0) {
                                    ForEach(0..<5) { _ in
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .frame(width: 24, height: 24)
                                    }
                                }
                                
                                //hstack containing the quality + review sources
                                HStack(alignment: .top, spacing: 28) {
                                    //Quality text with stars description
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Great Quality")
                                            .font(Theme.Typography.largeText)
                                            .foregroundColor(Theme.Typography.largeTextColor)
                                            .padding(.leading, 0)
                                        
                                        Text("4.5/5 stars")
                                            .font(Theme.Typography.smallBody)
                                            .foregroundColor(Theme.Typography.smallBodyColor)
                                            .padding(.leading, 0)
                                    }
                                    
                                    ZStack { // Main ZStack for layering
                                        // Bottom layer: Circles in HStack
                                        HStack(spacing: -6) { // Control overlap between circles
                                            
                                            // google circle (top)
                                            Circle()
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                .frame(width: 24, height: 24)
                                                .background(Circle().fill(Color.black))
                                                .overlay(
                                                    Image(Theme.Images.google)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 24, height: 24)
                                                        .foregroundColor(.white)
                                                )
                                                .zIndex(2)
                                            
                                            // bestbuy circle (underneath google)
                                            Circle()
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                .frame(width: 24, height: 24)
                                                .background(Circle().fill(Color.black))
                                                .overlay(
                                                    Image(Theme.Images.bestbuy)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 24, height: 24)
                                                        .foregroundColor(.white)
                                                )
                                                .zIndex(1)
                                            
                                            // +3 circle for more sources
                                            Circle()
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                .frame(width: 24, height: 24)
                                                .background(Circle().fill(Color.white))
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                        .frame(width: 24, height: 24)
                                                        .background(Circle().fill(Color.white))
                                                        .overlay(
                                                            Text("+3")
                                                                .font(Theme.Typography.smallBody)
                                                                .foregroundColor(Theme.Typography.smallBodyColor)
                                                        )
                                                        .zIndex(0)
                                                )
                                        }
                                        .offset(x: 64) // Control position of circle group
                                        .zIndex(1) // Circles group is at bottom
                                        
                                        // Top layer: Button
                                        Button(action: {
                                            //add our action here
                                        }) {
                                            HStack(spacing: 8) {
                                                Circle()
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                    .frame(width: 24, height: 24)
                                                    .background(Circle().fill(Color.black))
                                                    .overlay(
                                                        Image(Theme.Images.amazon)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 24, height: 24)
                                                            .foregroundColor(.white))
                                                    .padding(.leading, 0)
                                                
                                                Text("Amazon")
                                                    .font(Theme.Typography.smallBody)
                                                    .foregroundColor(Theme.Typography.smallBodyColor)
                                                    .padding(.trailing, 12)
                                            }
                                            .foregroundColor(.black)
                                            .padding(.vertical, 0)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(Color.white)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                            .fixedSize(horizontal: true, vertical: false)
                                        }
                                        .zIndex(2) // Button is on top
                                    }
                                }
                                
                                .padding(.top, 0)
                                
                                .padding(.top, 4)
                                .padding(.leading, 0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            .padding(.leading, 0)
                            .padding(.top, 0)
                            
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
                
                //spacer line
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 1)
                    .foregroundColor(Theme.spacerline)
                
                Spacer()
                
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
        .background(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


