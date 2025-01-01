import SwiftUI

struct ParallaxCarouselView: View {

    let horizontalPadding: CGFloat = 14
    let cornerRadiusConstant: CGFloat = 10
    let paddingConstant: CGFloat = 10

    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            
            VStack {
                GeometryReader(content: { geometry in
                    let size = geometry.size
                    ScrollView(.horizontal) {
                        HStack(spacing: 16) {
                            ForEach(Card.cards) { card in
                                GeometryReader(content: { proxy in
                                    let scrollViewWidth = proxy.size.width
                                    let minX = proxy.frame(in: .scrollView).minX
                                    let percentage = minX / scrollViewWidth
                                    
                                    Image(card.imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .offset(x: -percentage * 85)
                                        .frame(width: 225 * 2.5)
                                        .frame(width: 225)
                                        .frame(height: 320)
                                        .overlay(content: {
                                            ZStack(alignment: .topTrailing) {
                                                titleOverlayForCard(card)
                                                
                                                CircleButton(iconName: "arrow.up.right") {
                                                    // Action here
                                                }
                                                .padding(.top, 16)
                                                .padding(.trailing, 16)
                                            }
                                        })
                                        .clipShape(.rect(cornerRadius: cornerRadiusConstant))
                                })
                                .frame(width: 225, height: 320)
                                .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                    view.scaleEffect(phase.isIdentity ? 1 : 0.90)
                                }
                            }
                        }
                        .padding(.horizontal, horizontalPadding)
                        .scrollTargetLayout()
                        .frame(height: size.height, alignment: .top)
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                })

            }
        }
    }
    
    @ViewBuilder
    private func titleOverlayForCard(_ card: Card) -> some View {
        ZStack(alignment: .bottomLeading, content: {
            LinearGradient(colors: [
                .clear,
                .clear,
                .clear,
                .clear,
                .clear,
                //.black.opacity(0.2),
                .black.opacity(0.7),
                .black
            ], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(card.title)
                    .font(Theme.Typography.title)
                    .foregroundStyle(Color.white)
                
                Text(card.subTitle)
                    .font(Theme.Typography.subtitle)
                    .foregroundStyle(Color.white)
            }
            .padding(paddingConstant)
            .padding(.bottom, 16)
        })
    }
}

#Preview {
    ParallaxCarouselView()
}
