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
struct BottomSheetView: View {
    var body: some View {
        VStack(spacing: 24) {
            Color.clear.frame(height: 8)
            ProductInfoSection()
            
            Rectangle()
                .frame(width: UIScreen.main.bounds.width * 0.8, height: 1)
                .foregroundColor(Theme.spacerline)
            
            Spacer()
            BottomIconsSection()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.white)
    }
}

// Main product info section
struct ProductInfoSection: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ProductImage()
            ProductDetails()
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 24)
    }
}

// Product image component
struct ProductImage: View {
    var body: some View {
        Image(Theme.Images.metaquest3)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 110, height: 126)
            .background(Color.gray.opacity(0.2))
            .clipped()
            .cornerRadius(10)
            .padding(.leading, -4)
    }
}

// Product details component
struct ProductDetails: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ProductTitleSection()
            RatingStars()
            ReviewSection()
        }
        .padding(.top, 0)
    }
}

// Product title section
struct ProductTitleSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Meta Quest 3")
                .font(Theme.Typography.title)
                .foregroundColor(Theme.Typography.titleColor)
            
            Text("Meta")
                .font(Theme.Typography.largeText)
                .foregroundColor(Theme.Typography.largeTextColor)
        }
        .padding(.top, 8)
    }
}

// Rating stars component
struct RatingStars: View {
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<5) { _ in
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .frame(width: 24, height: 24)
            }
        }
    }
}

// Review section component
struct ReviewSection: View {
    var body: some View {
        HStack(alignment: .top, spacing: 28) {
            QualityRating()
            ReviewSourcesSection()
        }
        .padding(.top, 4)
    }
}

// Quality rating component
struct QualityRating: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Great Quality")
                .font(Theme.Typography.largeText)
                .foregroundColor(Theme.Typography.largeTextColor)
            
            Text("4.5/5 stars")
                .font(Theme.Typography.smallBody)
                .foregroundColor(Theme.Typography.smallBodyColor)
        }
    }
}

// Review sources section
struct ReviewSourcesSection: View {
    var body: some View {
        ZStack {
            ReviewSourceCircles()
                .offset(x: 64)
                .zIndex(1)
            
            AmazonButton()
                .zIndex(2)
        }
    }
}

// Review source circles
struct ReviewSourceCircles: View {
    var body: some View {
        HStack(spacing: -6) {
            SourceCircle(image: Theme.Images.google)
                .zIndex(2)
            
            SourceCircle(image: Theme.Images.bestbuy)
                .zIndex(1)
            
            PlusThreeCircle()
                .zIndex(0)
        }
    }
}

// Source circle component
struct SourceCircle: View {
    let image: String
    
    var body: some View {
        Circle()
            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            .frame(width: 24, height: 24)
            .background(Circle().fill(Color.black))
            .overlay(
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            )
    }
}

// Plus three circle component
struct PlusThreeCircle: View {
    var body: some View {
        Circle()
            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            .frame(width: 24, height: 24)
            .background(Circle().fill(Color.white))
            .overlay(
                Text("+3")
                    .font(Theme.Typography.smallBody)
                    .foregroundColor(Theme.Typography.smallBodyColor)
            )
    }
}

// Amazon button component
struct AmazonButton: View {
    var body: some View {
        Button(action: {
            //add our action here
        }) {
            HStack(spacing: 8) {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(Color.black))
                    .overlay(
                        Image(systemName: "checkmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                    )
                
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
    }
}

// Bottom icons section
struct BottomIconsSection: View {
    var body: some View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


