import SwiftUI

struct RecentRecs: View {
    let recommendations: RecommendationList
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero Image
                    ZStack(alignment: .topLeading) {
                        Image(recommendations.searchedProduct.imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                            .clipped()
                        
                        // Enhanced gradient overlay
                        LinearGradient(
                            colors: [
                                .black.opacity(0.5),
                                .black.opacity(0.2),
                                .clear,
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        // Back button
                        CircleButton(iconName: "arrow.left") {
                            dismiss()
                        }
                        .padding(.top, 60)
                        .padding(.leading, 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
                        // Title section
                        VStack(alignment: .leading, spacing: 16) {
                            Text(recommendations.searchedProduct.title)
                                .font(.system(size: 34, weight: .bold))
                                .lineSpacing(0.4)
                                .padding(.top, 24)
                            
                            // Source info
                            HStack(spacing: 12) {
                                HStack(spacing: -8) {
                                    SourceCircle(image: Theme.Images.amazon)
                                        .zIndex(3)
                                    SourceCircle(image: Theme.Images.google)
                                        .zIndex(2)
                                    SourceCircle(image: Theme.Images.bestbuy)
                                        .zIndex(1)
                                }
                                
                                Text("Compiled from \(recommendations.searchedProduct.sourceCount) sources")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Refined divider
                        Divider()
                            .padding(.horizontal, 20)
                        
                        // Recommendations section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Because you searched")
                                .font(.system(size: 22, weight: .bold))
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 24) {
                                ForEach(recommendations.products) { product in
                                    ProductRow(product: product)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .navigationBarHidden(true)
        .environment(\.colorScheme, .light)
    }
}

struct ProductRow: View {
    let product: RecommendationProduct
    
    var body: some View {
        HStack(spacing: 16) {
            // Product image
            Image(product.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Product details
            VStack(alignment: .leading, spacing: 8) {
                Text(product.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text(product.description)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                // Rating and source
                HStack(spacing: 12) {
                    HStack(spacing: -8) {
                        SourceCircle(image: Theme.Images.amazon)
                            .zIndex(3)
                        SourceCircle(image: Theme.Images.google)
                            .zIndex(2)
                        SourceCircle(image: Theme.Images.bestbuy)
                            .zIndex(1)
                    }
                    
                    Text("\(product.sourceCount) sources")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
    }
}

// Data Models
struct RecommendationList {
    let searchedProduct: SearchedProduct
    let products: [RecommendationProduct]
    
    struct SearchedProduct {
        let title: String
        let imageUrl: String
        let sourceCount: Int
    }
}

struct RecommendationProduct: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageUrl: String
    let sourceCount: Int
    let rating: Double
}

// Sample Data
extension RecommendationList {
    static let sample = RecommendationList(
        searchedProduct: SearchedProduct(
            title: "MacBook Air M2",
            imageUrl: "laptopsmid",
            sourceCount: 8
        ),
        products: [
            RecommendationProduct(
                title: "Magic Keyboard",
                description: "The perfect companion for your MacBook with amazing typing experience",
                imageUrl: "laptopsmid",
                sourceCount: 6,
                rating: 4.5
            ),
            RecommendationProduct(
                title: "LG UltraFine Display",
                description: "4K display with perfect color accuracy and USB-C connectivity",
                imageUrl: "watchesmid",
                sourceCount: 8,
                rating: 4.7
            ),
            RecommendationProduct(
                title: "Twelve South BookArc",
                description: "Vertical stand to save desk space and improve cooling",
                imageUrl: "phonesmid",
                sourceCount: 4,
                rating: 4.3
            )
        ]
    )
}

#Preview {
    NavigationView {
        RecentRecs(recommendations: .sample)
    }
    .preferredColorScheme(.light)
} 
