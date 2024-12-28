import Foundation

struct BottomSheetData {
    let barcode: Int
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
    static func fetch(barcode: Int) async throws -> BottomSheetData {
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
        
        let bottomSheetData = BottomSheetData(
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
            _pros: response.review_summary.pros,
            _cons: response.review_summary.cons
        )
        
        print("Image URL in BottomSheetData:", bottomSheetData.imageUrl)
        return bottomSheetData
    }
    
    // Example data
    static let example = BottomSheetData(
        barcode: 305212750003,
        productTitle: "Vaseline Lip Therapy Advanced Healing",
        companyName: "Vaseline",
        reviewCount: 1230,
        descriptionText: "Reviewers generally praise the Vaseline Lip Therapy Advanced Healing Ointment for its effective healing and moisturizing properties. However, some users find the ointment to be greasy and sticky, which can be a drawback for those who prefer a lighter texture.",
        starRating: 4.3,
        companyTitle: "Health & Beauty",
        companyGenre: "Personal Care",
        companyValue: 4.3,
        companyTrust: "Trusted",
        imageUrl: "https://pics.walgreens.com/prodimg/15848/450.jpg",
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
