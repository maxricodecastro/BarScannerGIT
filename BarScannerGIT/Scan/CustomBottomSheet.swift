import SwiftUI

//content of the sheet
struct BottomSheetView: View {
    @EnvironmentObject var viewModel: BottomSheetViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                Color.clear.frame(height: 8)
                
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
        VStack(spacing: 44){
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
        HStack(alignment: .top) {
            ProductImage()
            ProductDetails()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 24)
    }
}

// Product image component
struct ProductImage: View {
    @EnvironmentObject var viewModel: BottomSheetViewModel
    
    var body: some View {
        let imageUrl = viewModel.data.imageUrl
        
        AsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 117, height: 142)
                    .background(Color.gray.opacity(0.2))
                    .clipped()
                    .cornerRadius(10)
                    .padding(.leading, -4)
            case .failure(let error):
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 110, height: 126)
                    .background(Color.gray.opacity(0.2))
                    .clipped()
                    .cornerRadius(10)
                    .padding(.leading, -4)
            default:
                ProgressView()
                    .frame(width: 110, height: 126)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.leading, -4)
            }
        }
    }
}

// Product details component
struct ProductDetails: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ProductTitleSection()
            RatingStars()
        }
        .padding(.top, 0)
    }
}

// Product title section
struct ProductTitleSection: View {
    @EnvironmentObject var viewModel: BottomSheetViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 16) {
                Text(viewModel.data.productTitle)
                    .font(Theme.Typography.title)
                    .foregroundColor(Theme.Typography.titleColor)
                    .lineLimit(3)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7)
                
                Spacer(minLength: 16)
                
                Text(viewModel.data.price)
                    .font(Theme.Typography.subtitle)
                    .foregroundStyle(Theme.Typography.titleColor)
                    .frame(minWidth: UIScreen.main.bounds.width * 0.15)
                    .lineLimit(1)
            }
            
            Text(viewModel.data.companyName)
                .font(Theme.Typography.largeText)
                .foregroundColor(Theme.Typography.largeTextColor)
        }
        .padding(.trailing, UIScreen.main.bounds.width * 0.05)
    }
}

// Rating stars component
struct RatingStars: View {
    @EnvironmentObject var viewModel: BottomSheetViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                // Action here if needed
            }) {
                HStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color(hex: "FFD250"))
                            .frame(width: 15, height: 15)
                        
                        Text(viewModel.data.starRatingFormatted)
                            .font(Theme.Typography.starsText)
                            .foregroundColor(Theme.Typography.starsTextColor)
                    }
                    
                    Text("Great buy")
                        .font(Theme.Typography.recommendedText)
                        .foregroundColor(Theme.Typography.recommendedTextColor)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Theme.companyColorGreen)
                .cornerRadius(24)
            }

            
            VStack(spacing: 0) {
                HStack {
                    Text(viewModel.data.reviewCountFormatted + " reviews")
                        .font(Theme.Typography.reviewBody)
                        .foregroundStyle(Color(hex: "9E9E9E"))
                    
                    Spacer()
                    
                    ReviewSourceCircles()
                        .offset(y:24)
                }
            }
            .padding(.trailing, UIScreen.main.bounds.width * 0.05)
        }
    }
}

//// Review source circles
//struct ReviewSourceCircles: View {
//    var body: some View {
//        HStack(spacing: -8) {
//
//            SourceCircle(image: Theme.Images.amazon)
//                .zIndex(3)
//
//            SourceCircle(image: Theme.Images.google)
//                .zIndex(2)
//
//            SourceCircle(image: Theme.Images.bestbuy)
//                .zIndex(1)
//
//            PlusThreeCircle()
//                .zIndex(0)
//        }
//    }
//}

//// Source circle component
//struct SourceCircle: View {
//    let image: String
//
//    var body: some View {
//        Circle()
//            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//            .frame(width: 24, height: 24)
//            .background(Circle().fill(Color.black))
//            .overlay(
//                Image(image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 24, height: 24)
//                    .foregroundColor(.white)
//            )
//    }
//}

//// Plus three circle component
//struct PlusThreeCircle: View {
//    var body: some View {
//        Circle()
//            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//            .frame(width: 24, height: 24)
//            .background(Circle().fill(Color.white))
//            .overlay(
//                Text("+3")
//                    .font(Theme.Typography.smallBody)
//                    .foregroundColor(Theme.Typography.smallBodyColor)
//            )
//    }
//}

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
        VStack(alignment: .leading, spacing: 10) {
            BuyersHaveToSay()
            VStack(alignment: .leading, spacing: 8) {
                ReviewProsHStack()
                ReviewConsHStack()
            }
        }
    }
}



//Buyers have to say text
struct BuyersHaveToSay: View {
    var body: some View {
        Text("Buyers have to say")
            .font(Theme.Typography.smallerTitle)
            .foregroundColor(Theme.Typography.smallerTitleColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, UIScreen.main.bounds.width * 0.06)
    }
}


struct ReviewProsTemplate: View {
    let text: String
    
    var body: some View {
        Button(action: {
            //add our action here
        }) {
            HStack(spacing: 12) { // Adjust circle-to-text spacing here
                Circle()
                    .fill(Theme.companyColorGreen)
                    .frame(width: 8, height: 8)
                    .padding(.leading, UIScreen.main.bounds.width * 0.04)
                    .padding(.trailing, 4)
                    .padding(.vertical, 8)
                
                Text(text)
                    .font(Theme.Typography.smallBody)
                    .foregroundColor(Theme.Typography.reviewTextColor)
                    .padding(.vertical, 8)
                    .padding(.trailing, UIScreen.main.bounds.width * 0.04)
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
        .frame(minWidth: UIScreen.main.bounds.width * 0.25)
        .frame(height: 36)
    }
}

struct ReviewConsTemplate: View {
    let text: String
    
    var body: some View {
        Button(action: {
            //add our action here
        }) {
            HStack(spacing: 12) { // Match spacing with pros template
                Circle()
                    .fill(Theme.CompanyColorRed)
                    .frame(width: 8, height: 8)
                    .padding(.leading, UIScreen.main.bounds.width * 0.04)
                    .padding(.trailing, 4)
                    .padding(.vertical, 8)
                
                Text(text)
                    .font(Theme.Typography.smallBody)
                    .foregroundColor(Theme.Typography.reviewTextColor)
                    .padding(.vertical, 8)
                    .padding(.trailing, UIScreen.main.bounds.width * 0.04)
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
        .frame(minWidth: UIScreen.main.bounds.width * 0.25)
        .frame(height: 36)
    }
}

struct ReviewProsHStack: View {
    @EnvironmentObject var viewModel: BottomSheetViewModel
    
    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(viewModel.data.pros.indices, id: \.self) { index in
                ReviewProsTemplate(text: viewModel.data.pros[index])
            }
        }
        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ReviewConsHStack: View {
    @EnvironmentObject var viewModel: BottomSheetViewModel
    
    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(viewModel.data.cons.indices, id: \.self) { index in
                ReviewConsTemplate(text: viewModel.data.cons[index])
            }
        }
        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// Custom FlowLayout that wraps items
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var height: CGFloat = 0
        var currentRow: CGFloat = 0
        var currentX: CGFloat = 0
        
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            
            if currentX + size.width > maxWidth {
                // Move to next row
                height += currentRow + spacing
                currentRow = size.height
                currentX = size.width + spacing
            } else {
                currentX += size.width + spacing
                currentRow = max(currentRow, size.height)
            }
        }
        
        height += currentRow
        return CGSize(width: maxWidth, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX = bounds.minX
        var currentY = bounds.minY
        var rowHeight: CGFloat = 0
        
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            
            if currentX + size.width > bounds.maxX {
                // Move to next row
                currentX = bounds.minX
                currentY += rowHeight + spacing
                rowHeight = 0
            }
            
            view.place(
                at: CGPoint(x: currentX, y: currentY),
                proposal: ProposedViewSize(size)
            )
            
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

struct Description: View {
    @EnvironmentObject var viewModel: BottomSheetViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Things to consider")
                .font(Theme.Typography.smallerTitle)
                .foregroundColor(Theme.Typography.smallerTitleColor)
            
            Text(viewModel.data.descriptionText)
                .font(Theme.Typography.largeText)
                .foregroundStyle(Theme.Typography.largeTextColor)
                .frame(width: UIScreen.main.bounds.width * 0.88, alignment: .leading) // Control text width
        }
        .padding(.leading, UIScreen.main.bounds.width * 0.06)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct Company: View {
    @EnvironmentObject var viewModel: BottomSheetViewModel
    
    var body: some View {
        VStack {
            Color.clear.frame(height: 4)

            HStack {
                // Left side content
                HStack(spacing: 0) { // Changed spacing to 0
                    Circle()
                        .fill(Theme.companyColorGreen)
                        .frame(width: 42, height: 42)
                        .overlay(
                            Text(viewModel.data.companyValueFormatted)
                                .font(Theme.Typography.companyText)
                                .foregroundStyle(Theme.Typography.companyTextColor)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) { // Added alignment: .leading
                        Text(viewModel.data.companyTitle)
                            .font(Theme.Typography.smallerTitle)
                            .foregroundStyle(Theme.Typography.smallerTitleColor)
                        
                        Text(viewModel.data.companyGenre)
                            .font(Theme.Typography.smallBody)
                            .foregroundStyle(Theme.Typography.smallBodyColor)
                    }
                    .padding(.leading, 8) // Added small padding after circle
                }
                .padding(.leading, UIScreen.main.bounds.width * 0.06)
                
                Spacer()
                
                Text(viewModel.data.companyTrust)
                    .font(Theme.Typography.companyText)
                    .foregroundStyle(Theme.Typography.largeTextColor)
                    .padding(.trailing, UIScreen.main.bounds.width * 0.06)
            }
        }
        
        .frame(maxWidth: .infinity)
    }
}

struct NotificationsView: View {
    @State private var showingNoProductSheet = false
    
    var body: some View {
        VStack {
            Button(action: {
                showingNoProductSheet = true
            }) {
                Text("Test No Product Sheet")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .cornerRadius(12)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
        .sheet(isPresented: $showingNoProductSheet) {
            NoProductSheet()
                .presentationDetents([.fraction(0.25)])
                .presentationBackground(.white)
        }
    }
}

struct BottomSheetTestView: View {
    @State var showingBottomSheet = false
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @StateObject private var viewModel = BottomSheetViewModel()
    
    var body: some View {
        VStack {
            Button(action: {
                Task {
                    isLoading = true
                    do {
                        let data = try await BottomSheetData.fetch(barcode: "887276069623")
                        await MainActor.run {
                            viewModel.updateData(data)
                            showingBottomSheet = true
                            isLoading = false
                        }
                    } catch {
                        await MainActor.run {
                            errorMessage = error.localizedDescription
                            showError = true
                            isLoading = false
                        }
                    }
                }
            }) {
                HStack(spacing: 8) {
                    if isLoading {
                        ProgressView()
                            .tint(.black)
                    }
                    Text(isLoading ? "Loading..." : "Test API Call")
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
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
        .sheet(isPresented: $showingBottomSheet) {
            BottomSheetView()
                .environmentObject(viewModel)
                .presentationDetents([
                    .fraction(0.25),
                    .fraction(0.8)
                ])
                .presentationBackground(.white)
        }
    }
}

struct BottomSheetExampleView: View {
    @State var showingBottomSheet = false
    @StateObject private var viewModel = BottomSheetViewModel()
    
    var body: some View {
        VStack {
            Button(action: {
                viewModel.data = BottomSheetData.example
                showingBottomSheet = true
            }) {
                HStack(spacing: 8) {
                    Text("Test UI with Example Data")
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
                .environmentObject(viewModel)
                .presentationDetents([
                    .fraction(0.25),
                    .fraction(0.8)
                ])
                .presentationBackground(.white)
        }
    }
}
