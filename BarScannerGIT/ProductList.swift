import Foundation

struct ProductList: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let items: [ProductListItem]
    
    struct ProductListItem: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let imageUrl: String
    }
    
    // Sample data
    static let sampleList = ProductList(
        title: "History",
        subtitle: "Recent product searches",
        items: [
            ProductListItem(
                title: "MacBook Air M2",
                subtitle: "March 14, 2024",
                imageUrl: "laptopsmid"
            ),
            ProductListItem(
                title: "Sony WH-1000XM5",
                subtitle: "March 13, 2024",
                imageUrl: "watchesmid"
            ),
            ProductListItem(
                title: "iPhone 15 Pro",
                subtitle: "March 12, 2024",
                imageUrl: "phonesmid"
            ),
            ProductListItem(
                title: "iPad Air",
                subtitle: "March 11, 2024",
                imageUrl: "laptopsmid"
            ),
            ProductListItem(
                title: "AirPods Pro 2",
                subtitle: "March 10, 2024",
                imageUrl: "watchesmid"
            )
        ]
    )
} 
