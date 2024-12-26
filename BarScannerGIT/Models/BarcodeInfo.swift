import Foundation

struct BarcodeInfo: Codable {
    let barcode: String
    let title: String
    let description: String?
    let brand: String?
    let category: String?
    
    init(from response: BigProductResponse) {
        self.barcode = response.gtin
        if let firstTitle = response.properties.title?.first {
            self.title = firstTitle
        } else {
            self.title = "Unknown Product"
        }
        self.brand = response.properties.brand?.first
        self.description = response.properties.description?.first
        self.category = response.properties.category?.first
    }
} 
