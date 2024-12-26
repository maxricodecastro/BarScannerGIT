import Foundation

enum BarcodeError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}

protocol BarcodeServiceProtocol {
    func fetchProductInfo(barcode: String) async throws -> BarcodeInfo
}

final class BarcodeService: BarcodeServiceProtocol {
    private let baseURL = "https://big-product-data.p.rapidapi.com/gtin"
    private let apiKey = "a2a5e1504cmshf9a4a37018883d2p11f3c6jsn77a459faea4d"
    private let apiHost = "big-product-data.p.rapidapi.com"
    
    func fetchProductInfo(barcode: String) async throws -> BarcodeInfo {
        print("\n=== Starting Barcode Lookup ===")
        print("📱 Processing barcode: \(barcode)")
        
        let urlString = "\(baseURL)/\(barcode)"
        guard let url = URL(string: urlString) else {
            print("❌ Error: Invalid URL created")
            throw BarcodeError.invalidURL
        }
        
        print("🌐 API Request URL: \(url.absoluteString)")
        print("🔑 Using RapidAPI Host: \(apiHost)")
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue(apiHost, forHTTPHeaderField: "X-RapidAPI-Host")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        print("📤 Sending API request...")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Error: Invalid HTTP response received")
                throw BarcodeError.networkError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
            }
            
            print("📥 Response received")
            print("📊 Status code: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 Raw response data:")
                print(responseString)
            }
            
            guard httpResponse.statusCode == 200 else {
                print("❌ Error: Bad status code: \(httpResponse.statusCode)")
                throw BarcodeError.networkError(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server returned status code \(httpResponse.statusCode)"]))
            }
            
            print("🔍 Decoding response data...")
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(BigProductResponse.self, from: data)
                print("✅ Successfully decoded product data:")
                print("   Name: \(response.properties.title?.first ?? "N/A")")
                print("   Brand: \(response.properties.brand?.first ?? "N/A")")
                print("   Category: \(response.properties.category?.first ?? "N/A")")
                print("   Has Images: \(response.stores?.isEmpty == false ? "Yes" : "No")")
                
                return BarcodeInfo(from: response)
            } catch {
                print("❌ Decoding error: \(error)")
                print("   Error details: \(error.localizedDescription)")
                throw BarcodeError.decodingError(error)
            }
        } catch {
            print("❌ Network error: \(error)")
            print("   Error details: \(error.localizedDescription)")
            throw BarcodeError.networkError(error)
        }
    }
}

struct BigProductResponse: Codable {
    let gtin: String
    let properties: Properties
    let stores: [Store]?
}

struct Properties: Codable {
    let title: [String]?
    let brand: [String]?
    let description: [String]?
    let category: [String]?
    let manufacturer: [String]?
}

struct Store: Codable {
    let store: String
    let price: StorePrice?
}

struct StorePrice: Codable {
    let currency: String?
    let price: PriceValue?
    let sale: PriceValue?
}

enum PriceValue: Codable {
    case string(String)
    case number(Double)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let numberValue = try? container.decode(Double.self) {
            self = .number(numberValue)
        } else {
            throw DecodingError.typeMismatch(PriceValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String or Double"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value)
        }
    }
} 
