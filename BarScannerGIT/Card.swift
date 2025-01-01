import Foundation

struct Card: Identifiable {
    let id = UUID().uuidString
    let title: String
    let subTitle: String
    let imageName: String
    
    static let cards: [Card] = [
        Card(title: "The best laptops for students in 2024", subTitle: "Compiled from 8 sources", imageName: "laptopsmid"),
        Card(title: "Phone cases for durability ", subTitle: "Compiled from 6 sources", imageName: "phonesmid"),
        Card(title: "Jeans that we know will fit", subTitle: "Compiled from 4 sources", imageName: "jeansmid"),
        Card(title: "Timeless watches for 2025", subTitle: "Compiled from 12 sources", imageName: "watchesmid"),
        Card(title: "Running shoes for the new years", subTitle: "Compiled form 7 sources", imageName: "shoesmid")
    ]
} 
