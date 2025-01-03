import SwiftUI

struct TextCarouselView: View {
    struct TextCard: Identifiable {
        let id = UUID()
        let title: String
        let subTitle: String
        let backgroundImage: String
    }
    
    private let cards: [TextCard] = [
        TextCard(title: "Electronics", subTitle: "Latest gadgets", backgroundImage: "seaback"),
        TextCard(title: "Fashion", subTitle: "Trending styles", backgroundImage: "torqueback"),
        TextCard(title: "Home", subTitle: "Decor & more", backgroundImage: "redback"),
        TextCard(title: "Sports", subTitle: "Equipment & gear", backgroundImage: "greenback"),
        TextCard(title: "Books", subTitle: "Best sellers", backgroundImage: "goldback"),
        TextCard(title: "Gaming", subTitle: "Latest releases", backgroundImage: "blueback"),
        TextCard(title: "Health", subTitle: "Wellness products", backgroundImage: "bloodback"),
        TextCard(title: "Tech", subTitle: "New arrivals", backgroundImage: "blackback")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(cards) { card in
                    TextCardView(card: card)
                }
            }
            .padding(.horizontal, 28)
        }
    }
}

struct TextCardView: View {
    let card: TextCarouselView.TextCard
    let paddingConstant: CGFloat = 10
    let cornerRadiusConstant: CGFloat = 20
    @State private var showRecentRecs = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background image
            Image(card.backgroundImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 200)
            
            // Content
            VStack(alignment: .leading, spacing: 5) {
                Spacer()
                
                Text(card.subTitle)
                    .font(Theme.Typography.subtitle)
                    .foregroundStyle(Color.white)
                
                Text(card.title)
                    .font(Theme.Typography.title)
                    .foregroundStyle(Color.white)
            }
            .padding(paddingConstant)
            .padding(.bottom, 16)
            
            // Top-right button
            VStack {
                HStack {
                    Spacer()
                    CircleButton(iconName: "arrow.up.right") {
                        showRecentRecs = true
                    }
                    .padding(.top, 16)
                    .padding(.trailing, 16)
                }
                Spacer()
            }
        }
        .frame(width: 160, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadiusConstant))
        .onTapGesture {
            showRecentRecs = true
        }
        .fullScreenCover(isPresented: $showRecentRecs) {
            RecentRecs(recommendations: RecommendationList(
                searchedProduct: RecommendationList.SearchedProduct(
                    title: card.title,
                    imageUrl: card.backgroundImage,
                    sourceCount: 8
                ),
                products: RecommendationList.sample.products
            ))
        }
    }
}

#Preview {
    TextCarouselView()
} 
