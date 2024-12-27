import SwiftUI

struct Theme {
    // Original color schemes
    static let background = Color.white
    static let text = Color.black
    static let secondaryText = Color.gray
    static let primary = Color.blue
    static let border = Color.gray.opacity(0.3)
    static let success = Color.green
    static let warning = Color.orange
    static let star = Color.yellow
    static let spacerline = Color(hex: "D9D9D9")
    
    
    // New Typography system
    struct Typography {
        // Title - 18px (Product Title)
        static let title = Font.system(size: 18, weight: .bold)
        static let titleColor = Color.black
        
        // Subtitle - 14px SF Pro Semibold - Black
        static let smallerTitle = Font.system(size: 14, weight: .semibold)
        static let smallerTitleColor = Color.black
        
        // Body text - 14px SF Pro Regular - #8F8F8F
        static let largeText = Font.system(size: 14, weight: .regular)
        static let largeTextColor = Color(hex: "8F8F8F")
        
        // Body text - 14px SF Pro Regular - #717171
        static let subtitle = Font.system(size: 14, weight: .regular)
        static let subtitleColor = Color(hex: "717171")
        
        //Small Text - 12px SF Pro Regular - #BABABA
        static let smallBody = Font.system(size: 12, weight : .regular)
        static let smallBodyColor = Color(hex: "BABABA")
    }
    
    struct Images {
        static let google = "googlelogo"
        static let bestbuy = "bestbuylogo"
        static let amazon = "amazonlogo"
        static let metaquest3 = "metaquest3"
    }
}

// Helper extension to create Colors from hex values
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

