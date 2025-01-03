import SwiftUI

struct ParallaxCarouselView: View {
    @State private var selectedCard: Card?
    @Environment(\.dismiss) private var dismiss
    
    let horizontalPadding: CGFloat = 14
    let cornerRadiusConstant: CGFloat = 10
    let paddingConstant: CGFloat = 10
    
    var body: some View {
        CarouselContent(selectedCard: $selectedCard)
            .fullScreenCover(item: $selectedCard) { card in
                NewsArticleView(article: card.article, selectedCard: $selectedCard)
                    .background(Color.white)
                    .environment(\.colorScheme, .light) // Force light mode

            }
    }
}

// Separate view for the main carousel content
struct CarouselContent: View {
    @Binding var selectedCard: Card?
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            VStack {
                GeometryReader { geometry in
                    ScrollView(.horizontal) {
                        CarouselStack(selectedCard: $selectedCard)
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                }
            }
        }
    }
}

// Separate view for the carousel stack
struct CarouselStack: View {
    @Binding var selectedCard: Card?
    let horizontalPadding: CGFloat = 28
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(Card.cards) { card in
                CarouselCard(card: card, selectedCard: $selectedCard)
            }
        }
        .padding(.horizontal, horizontalPadding)
        .scrollTargetLayout()
    }
}

// Separate view for individual cards
struct CarouselCard: View {
    let card: Card
    @Binding var selectedCard: Card?
    let cornerRadiusConstant: CGFloat = 10
    
    var body: some View {
        GeometryReader { proxy in
            let scrollViewWidth = proxy.size.width
            let minX = proxy.frame(in: .scrollView).minX
            let percentage = minX / scrollViewWidth
            
            CardContent(
                card: card,
                percentage: percentage,
                selectedCard: $selectedCard
            )
        }
        .frame(width: 225, height: 320)
        .scrollTransition(.interactive, axis: .horizontal) { view, phase in
            view.scaleEffect(phase.isIdentity ? 1 : 0.85)
        }
    }
}

// Separate view for card content
struct CardContent: View {
    let card: Card
    let percentage: CGFloat
    @Binding var selectedCard: Card?
    let cornerRadiusConstant: CGFloat = 10
    let paddingConstant: CGFloat = 10
    
    var body: some View {
        ZStack {
            Image(card.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(x: -percentage * 85)
                .frame(width: 225 * 2.5)
                .frame(width: 225)
                .frame(height: 320)
                .clipped()
            
            // Overlay content
            ZStack(alignment: .topTrailing) {
                CardOverlay(card: card)
                
                CircleButton(iconName: "arrow.up.right") {
                    selectedCard = card
                }
                .padding(.top, 16)
                .padding(.trailing, 16)
            }
        }
        .clipShape(.rect(cornerRadius: cornerRadiusConstant))
        .contentShape(Rectangle())
        .onTapGesture {
            selectedCard = card
        }
    }
}

// Separate view for card overlay
struct CardOverlay: View {
    let card: Card
    let paddingConstant: CGFloat = 10
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [
                .clear,
                .clear,
                .clear,
                .clear,
                .clear,
                .black.opacity(0.7),
                .black
            ], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(card.title)
                    .font(Theme.Typography.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                    .lineSpacing(0.2)
                
                Text(card.subTitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .lineSpacing(0.3)
            }
            .padding(paddingConstant)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    ParallaxCarouselView()
}
