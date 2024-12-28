import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var showingBottomSheet = false
    @StateObject private var cameraViewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            // Main content
            switch selectedTab {
            case 0:
                HomeView()
                    .sheet(isPresented: $showingBottomSheet) {
                        BottomSheetView()
                            .presentationDetents([
                                .fraction(0.3),
                                .fraction(0.8)
                            ])
                            .presentationBackground(.white)
                            .presentationCornerRadius(20)
                            .presentationDragIndicator(.visible)
                    }
                    .zIndex(1) // Bottom sheet above main content
            case 1:
                Text("Search")
            case 2:
                Text("Camera view")
            case 3:
                Text("Notifications")
            case 4:
                Text("Profile")
            default:
                Text("Unknown Tab")
            }
            
            // Tab bar always on top
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(.keyboard)
            .zIndex(2) // Tab bar above everything
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
                .presentationDetents([
                    .fraction(0.25),  // Compact mode - only ProductInfoSection
                    .fraction(0.8)   // Expanded mode - full content
                ])
                .presentationBackground(.white)
        }
    }
}


//content of the sheet
struct BottomSheetView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                Color.clear.frame(height: 12)
                
                ProductInfoSection()
            
                DetailsStack()
                                
                Description()
                                
                Company()
                
                
            }
        }
        
    }
}

// Main product info section
struct ProductInfoSection: View {
    var body: some View {
        VStack(spacing: 20){
            ProductInfoSectionComponent()
            
            Rectangle()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 1)
                .foregroundColor(Theme.spacerline)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
struct ProductInfoSectionComponent: View {
    var body: some View {
        HStack {
            ProductImage()
            ProductDetails()
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
        }
        .padding(.top, 0)
    }
}

// Product title section
struct ProductTitleSection: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Meta Quest 3")
                    .font(Theme.Typography.title)
                    .foregroundColor(Theme.Typography.titleColor)
                
                Spacer()
                
                Text("$299")
                    .font(Theme.Typography.subtitle)
                    .foregroundStyle(Theme.Typography.titleColor)
                    


            }
            
            Text("Meta")
                .font(Theme.Typography.largeText)
                .foregroundColor(Theme.Typography.largeTextColor)
        }
        .padding(.trailing, UIScreen.main.bounds.width * 0.05)
    }
}

// Rating stars component
struct RatingStars: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) { // Small spacing between star and text
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .frame(width: 24, height: 14)
                
                Text("4.5")
                    .font(Theme.Typography.smallerTitle)
                    .foregroundColor(Theme.Typography.smallerTitleColor)
            }
            VStack(spacing: 4) {
                Text("Recommended")
                    .font(Theme.Typography.largeText)
                    .foregroundColor(Theme.Typography.largeTextColor)
                }
            
            HStack{
                Color.clear
                    .frame(width: 24, height: 24) // Adjust these values as needed
                
                Spacer()
                    .frame(width: UIScreen.main.bounds.width * 0.30) // 6% of screen width
                
                VStack(alignment: .trailing, spacing: 4) {
                    ReviewSourceCircles()
                    
                    Text("12,302 reviews")
                        .font(Theme.Typography.smallBody)
                        .foregroundStyle(Theme.Typography.smallBodyColor)
                }
                
            }
            
        }
        
    }
}

// Review section component
struct ReviewSection: View {
    var body: some View {
        HStack {
            Text("Recommended")
                .font(Theme.Typography.largeText)
                .foregroundColor(Theme.Typography.largeTextColor)
            
            VStack(alignment: .trailing, spacing: 4) {
                ReviewSourceCircles()
                
                Text("12,302 reviews")
                    .font(Theme.Typography.smallBody)
                    .foregroundStyle(Theme.Typography.smallBodyColor)
            }
        }
        .padding(.top, 4)
    }
}

// Review source circles
struct ReviewSourceCircles: View {
    var body: some View {
        HStack(spacing: -8) {
            
            SourceCircle(image: Theme.Images.amazon)
                .zIndex(3)
            
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


struct DetailsStack: View {
    var body: some View {
        VStack(spacing: 8) {
            BuyersHaveToSay()
            VStack(spacing: 8) {
                ReviewIconsHStack()
                ReviewIconsHStack()
            }
            
        }
    }
}



//Buyers have to say text
struct BuyersHaveToSay: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Buyers have to say")
                .font(Theme.Typography.smallerTitle)
                .foregroundColor(Theme.Typography.smallerTitleColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, UIScreen.main.bounds.width * 0.06)
    }
}

//Review Icons Template
struct ReviewIconsTemplate: View {
    var body: some View {
        Button(action: {
            //add our action here
        }) {
            HStack(spacing: 0) {
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)
                    .foregroundColor(.black)
                    .padding(.leading, UIScreen.main.bounds.width * 0.02) // 2% of screen width
                    .padding(.trailing, 0)
                    .padding(.vertical, 8)
                
                Text("Detail #1")
                    .font(Theme.Typography.largeText)
                    .foregroundColor(Theme.Typography.largeTextColor)
                    .padding(.vertical, 8)
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.04) // 4% of screen width
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .fixedSize(horizontal: true, vertical: false)
        .frame(minWidth: UIScreen.main.bounds.width * 0.25) // 25% of screen width minimum
        .frame(height: 36)
    }
}

struct ReviewIconsHStack: View {
    var body: some View {
        HStack(spacing: 8) {
            ReviewIconsTemplate()
            ReviewIconsTemplate()
            ReviewIconsTemplate()
        }
        .padding(.leading, UIScreen.main.bounds.width * 0.06)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct Description: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Things to consider")
                .font(Theme.Typography.smallerTitle)
                .foregroundColor(Theme.Typography.smallerTitleColor)
            
            Text("Battery life is limited (2-3 hours). Fit may vary; try before buying. Ideal for standalone VR but lacks PC-level graphics. Check app library, comfort, and storage capacity.")
                .font(Theme.Typography.largeText)
                .foregroundStyle(Theme.Typography.largeTextColor)
                .frame(width: UIScreen.main.bounds.width * 0.88, alignment: .leading) // Control text width
        }
        .padding(.leading, UIScreen.main.bounds.width * 0.06)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct Company: View {
    var body: some View {
        HStack {
            // Left side content
            HStack(spacing: 8) {
                Circle()
                    .fill(Theme.companyColorGreen)
                    .frame(width: 42, height: 42)
                    .overlay(
                        Text("7.2")
                            .font(Theme.Typography.companyText)
                            .foregroundStyle(Theme.Typography.companyTextColor)
                    )
                
                VStack(spacing: 4) {
                    Text("Company Title")
                        .font(Theme.Typography.smallerTitle)
                        .foregroundStyle(Theme.Typography.smallerTitleColor)
                    
                    Text("Company Genre")
                        .font(Theme.Typography.smallBody)
                        .foregroundStyle(Theme.Typography.smallBodyColor)
                }
            }
            .padding(.leading, UIScreen.main.bounds.width * 0.06) // Left padding
            
            Spacer() // Push content to sides
            
            // Right side content
            Text("Trusted")
                .font(Theme.Typography.companyText)
                .foregroundStyle(Theme.Typography.largeTextColor)
                .padding(.trailing, UIScreen.main.bounds.width * 0.06) // Right padding
        }
        .frame(maxWidth: .infinity) // Ensure HStack takes full width
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



