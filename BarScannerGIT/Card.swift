import Foundation

struct Card: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subTitle: String
    let imageName: String
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }
    
    var article: NewsArticle {
        let sourceCount = Int(subTitle.components(separatedBy: " ")[2]) ?? 0
        
        return NewsArticle(
            title: self.title,
            subtitle: self.subTitle,
            author: "Sarah Johnson",
            publication: "Tech Insights",
            publishDate: "March 14",
            imageUrl: self.imageName,
            content: NewsArticle.defaultContent,
            readTime: "5 min read",
            sourceCount: sourceCount
        )
    }
    
    static let cards: [Card] = [
        Card(title: "The best laptops for students in 2024", subTitle: "Compiled from 8 sources", imageName: "laptopsmid"),
        Card(title: "Phone cases for durability", subTitle: "Compiled from 6 sources", imageName: "phonesmid"),
        Card(title: "Jeans that we know will fit", subTitle: "Compiled from 4 sources", imageName: "jeansmid"),
        Card(title: "Timeless watches for 2025", subTitle: "Compiled from 12 sources", imageName: "watchesmid"),
        Card(title: "Running shoes for the new years", subTitle: "Compiled from 7 sources", imageName: "shoesmid")
    ]
}

// New struct for product components
struct ProductComponent: Identifiable {
    let id = UUID()
    let imageUrl: String
    let title: String
    let price: String
    let description: String
}

extension NewsArticle {
    static let defaultContent = NewsArticle.ArticleContent(
        introduction: """
        Finding the perfect laptop for your academic journey can be overwhelming with countless options available. We've analyzed reviews and expert opinions to bring you the most reliable recommendations that balance performance, value, and durability.
        """,
        
        products: [
            ProductComponent(
                imageUrl: "watchesmid",
                title: "MacBook Air M2",
                price: "$999",
                description: "Perfect for most students, the M2 MacBook Air offers exceptional battery life and performance in a lightweight package."
            ),
            ProductComponent(
                imageUrl: "phonesmid",
                title: "Dell XPS 13",
                price: "$899",
                description: "A premium Windows alternative with a stunning display and compact design, ideal for programming and creative work."
            ),
            ProductComponent(
                imageUrl: "jeansmid",
                title: "Lenovo Yoga 7i",
                price: "$749",
                description: "Versatile 2-in-1 design perfect for note-taking and creative work, with great battery life and solid performance."
            ),
            ProductComponent(
                imageUrl: "laptopsmid",
                title: "HP Envy x360",
                price: "$699",
                description: "Excellent value with premium features, including a touch screen and convertible design perfect for digital artists."
            ),
            ProductComponent(
                imageUrl: "shoesmid",
                title: "Acer Swift 3",
                price: "$599",
                description: "Budget-friendly yet powerful, offering great performance and battery life for everyday student tasks."
            ),
            ProductComponent(
                imageUrl: "watchesmid",
                title: "Asus ZenBook 14",
                price: "$799",
                description: "Sleek ultrabook with innovative features like the NumberPad and excellent build quality for long-term reliability."
            )
        ],
        
        conclusion: """
        While each laptop offers unique advantages, the key is to match your specific needs with the right features. Consider your course requirements, budget, and usage patterns when making your final decision. Remember that investing in a quality laptop now can serve you well throughout your academic career.
        """
    )
} 
