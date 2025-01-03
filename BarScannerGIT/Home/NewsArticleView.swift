import SwiftUI

struct NewsArticle: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let author: String
    let publication: String
    let publishDate: String
    let imageUrl: String
    let content: ArticleContent
    let readTime: String
    let sourceCount: Int
    
    // Move ArticleContent inside NewsArticle
    struct ArticleContent {
        let introduction: String
        let products: [ProductComponent]
        let conclusion: String
    }
    
    // Sample article data
    static let sampleArticle = NewsArticle(
        title: "The Future of Sustainable Technology",
        subtitle: "How innovation is driving environmental change in consumer electronics",
        author: "Sarah Johnson",
        publication: "Tech Insights",
        publishDate: "March 14",
        imageUrl: "laptopsmid",
        content: ArticleContent(
            introduction: """
            The landscape of consumer electronics is undergoing a radical transformation, with sustainability at its core. Major tech companies are not just innovating in terms of performance and features, but are increasingly focusing on environmental impact and longevity.

            Recent developments in recyclable materials and modular design are paving the way for a more sustainable future in technology. Companies are now exploring bio-degradable components and energy-efficient manufacturing processes that could revolutionize how we think about electronic devices.

            "We're seeing a fundamental shift in how companies approach product design," says Dr. Michael Chen, a leading researcher in sustainable technology. "It's no longer just about creating the most powerful device, but about creating one that can coexist harmoniously with our environment."

            The impact of these changes extends beyond just the devices themselves. Supply chains are being reimagined, with a growing emphasis on local sourcing and renewable energy in manufacturing. This holistic approach to sustainability is setting new standards for the industry.

            Consumer response to these initiatives has been overwhelmingly positive, with many expressing a willingness to pay premium prices for devices that align with their environmental values. This shift in consumer behavior is driving further innovation in the sector.

            Looking ahead, experts predict that sustainable technology will become the norm rather than the exception. As more companies adopt these practices, we're likely to see a cascade effect that could transform the entire industry.
            """,
            products: [],
            conclusion: ""
        ),
        readTime: "5 min read",
        sourceCount: 6
    )
}

struct NewsArticleView: View {
    let article: NewsArticle
    @Binding var selectedCard: Card?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Image
                ZStack(alignment: .topLeading) {
                    Image(article.imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 450)
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
                
                VStack(alignment: .leading, spacing: 32) {
                    // Article metadata
                    VStack(alignment: .leading, spacing: 24) {
                        // Title
                        Text(article.title)
                            .font(.system(size: 34, weight: .bold))
                            .lineSpacing(0.4)
                            .padding(.top, 32)
                        
                        // Author and date info
                        HStack(spacing: 16) {
                            Circle()
                                .fill(.blue)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Text(article.author.prefix(1))
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .semibold))
                                )
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(article.author)
                                    .font(.system(size: 17, weight: .semibold))
                                
                                HStack(spacing: 8) {
                                    Text(article.publication)
                                    Text("·")
                                    Text(article.publishDate)
                                    Text("·")
                                    Text(article.readTime)
                                }
                                .font(.system(size: 15))
                                .foregroundStyle(.secondary)
                            }
                        }
                        
                        // Source info
                        HStack(spacing: 12) {
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
                            
                            Text("Compiled from \(article.sourceCount) sources")
                                .font(.system(size: 15))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Refined divider
                    Divider()
                        .padding(.horizontal, 24)
                    
                    // Article content
                    VStack(alignment: .leading, spacing: 40) {
                        // Introduction
                        Text(article.content.introduction)
                            .font(.system(size: 18))
                            .lineSpacing(8)
                            .foregroundStyle(.primary.opacity(0.9))
                        
                        // Products section
                        if !article.content.products.isEmpty {
                            VStack(alignment: .leading, spacing: 32) {
                                Text("Top Picks")
                                    .font(.system(size: 28, weight: .bold))
                                
                                ForEach(article.content.products) { product in
                                    ProductView(product: product)
                                }
                            }
                        }
                        
                        // Conclusion
                        if !article.content.conclusion.isEmpty {
                            Text(article.content.conclusion)
                                .font(.system(size: 18))
                                .lineSpacing(8)
                                .foregroundStyle(.primary.opacity(0.9))
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: .top)
    }
}

// Refined ProductView with smaller price
struct ProductView: View {
    let product: ProductComponent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Product image
            Image(product.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Title and price
            HStack(alignment: .firstTextBaseline) {
                Text(product.title)
                    .font(.system(size: 22, weight: .semibold))
                
                Spacer()
                
                Text(product.price)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.primary.opacity(0.8))
            }
            
            // Description
            Text(product.description)
                .font(.system(size: 17))
                .foregroundStyle(.secondary)
                .lineSpacing(6)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NewsArticleView(
        article: NewsArticle.sampleArticle,
        selectedCard: .constant(nil)
    )
} 
