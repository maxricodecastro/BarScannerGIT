import Foundation

struct BottomSheetData {
    let barcode: String
    let productTitle: String
    let companyName: String
    let reviewCount: Int
    let descriptionText: String
    let starRating: Double
    let companyTitle: String
    let companyGenre: String
    let companyValue: Double
    let companyTrust: String
    let imageUrl: String
    let price: String
    private let _pros: [String]
    private let _cons: [String]
    
    // Computed properties for sorted arrays
    var pros: [String] {
        _pros.sorted { $0.count < $1.count }
    }
    
    var cons: [String] {
        _cons.sorted { $0.count < $1.count }
    }
    
    // Formatted strings
    var reviewCountFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: reviewCount)) ?? "\(reviewCount)"
    }
    
    var starRatingFormatted: String {
        String(format: "%.1f", starRating)
    }
    
    var companyValueFormatted: String {
        String(format: "%.1f", companyValue)
    }
    
    // API Response structs
    private struct APIResponse: Codable {
        let product: Product
        let rating: Double
        let review_summary: ReviewSummary
    }
    
    private struct Product: Codable {
        let name: String
        let brand: String
        let category: String
        let image_url: String
        let price: String
    }
    
    private struct ReviewSummary: Codable {
        let average_rating: Double
        let pros: [String]
        let cons: [String]
        let full_summary: String
    }
    
    // Static function to fetch and create BottomSheetData from API
    static func fetch(barcode: String) async throws -> BottomSheetData {
        let urlString = "https://qrbackend-ghtk.onrender.com/products/\(barcode)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        print("Raw JSON response:", String(data: data, encoding: .utf8) ?? "")
        
        let response = try JSONDecoder().decode(APIResponse.self, from: data)
        print("Image URL from API:", response.product.image_url)
        
        // Split category into title and genre
        let categoryComponents = response.product.category.components(separatedBy: " > ")
        let companyGenre = categoryComponents.first ?? ""
        let companyTitle = response.product.brand
        
        return BottomSheetData(
            barcode: barcode,
            productTitle: response.product.name,
            companyName: response.product.brand,
            reviewCount: 1230,
            descriptionText: response.review_summary.full_summary,
            starRating: response.rating,
            companyTitle: companyTitle,
            companyGenre: companyGenre,
            companyValue: response.review_summary.average_rating,
            companyTrust: "Trusted",
            imageUrl: response.product.image_url.replacingOccurrences(of: "http://", with: "https://"),
            price: response.product.price,
            _pros: response.review_summary.pros,
            _cons: response.review_summary.cons
        )
    }
    
    // Example data
    static let example = BottomSheetData(
        barcode: "887276069623",
        productTitle: "Vaseline Lip Therapy",
        companyName: "Vaseline",
        reviewCount: 1230,
        descriptionText: "Vaseline Lip Therapy provides effective healing and moisturizing for dry lips. While most users praise its long-lasting protection, some find the texture too thick and greasy for daily use.",
        starRating: 4.3,
        companyTitle: "Health & Beauty",
        companyGenre: "Personal Care",
        companyValue: 4.3,
        companyTrust: "Trusted",
        imageUrl: "https://pics.walgreens.com/prodimg/15848/450.jpg",
        price: "$4.99",
        _pros: [
            "Healing properties",
            "Moisturizing",
            "Long-lasting"
        ],
        _cons: [
            "Greasy feel",
            "Sticky texture"
        ]
    )
}
