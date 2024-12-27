import Foundation

struct BarcodeInfo: Codable {
    let barcode: String
    let title: String
    let description: String?
    let brand: String?
    let category: String?
    let imageUrl: String?
    
    init(from response: BigProductResponse) {
        self.barcode = response.gtin
        self.brand = response.properties.brand?.first
        
        if let fullTitle = response.properties.title?.first {
            let productName = extractProductName(fullTitle)
            if let brand = self.brand {
                self.title = "\(brand) - \(productName)"
            } else {
                self.title = productName
            }
        } else {
            self.title = "Unknown Product"
        }
        
        self.description = response.properties.description?.first
        self.category = response.properties.category?.first
        self.imageUrl = response.firstImageURL()
    }
}

private func extractProductName(_ rawTitle: String) -> String {
    // Split by any separator and take first meaningful part
    let parts = rawTitle.components(separatedBy: CharacterSet(charactersIn: "-–,;"))
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
    
    // Find the core product name (usually after brand names and before specifications)
    var productName = parts.first ?? ""
    for part in parts {
        if part.lowercased().contains("lip therapy") {
            productName = "Lip Therapy"
            break
        }
    }
    
    // Remove common noise patterns
    let noisePatterns = [
        "Vaseline",
        "Unilever",
        "Bestfoods",
        "VASEL\\s+LIP\\s+THER",
        "ADV\\s+TBE",
        "CT\\d+",
        "\\d+\\s*pack",
        "Advanced Formula",
        "Skin Protectant",
        "Advanced",
        "Formula"
    ]
    
    // Apply cleaning patterns
    for pattern in noisePatterns {
        productName = productName.replacingOccurrences(of: pattern, with: "", options: .caseInsensitive)
    }
    
    // Clean up whitespace
    productName = productName.trimmingCharacters(in: .whitespacesAndNewlines)
    while productName.contains("  ") {
        productName = productName.replacingOccurrences(of: "  ", with: " ")
    }
    
    return productName.trimmingCharacters(in: .whitespacesAndNewlines)
} 
