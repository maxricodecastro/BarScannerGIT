import SwiftUI

// Review source circles
struct ReviewSourceCircles: View {
    var body: some View {
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
    }
}

// Source circle component
struct SourceCircle: View {
    let image: String
    
    var body: some View {
        Circle()
            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            .frame(width: 24, height: 24)
            .background(Circle().fill(Color.black))
            .overlay(
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            )
    }
}

// Plus three circle component
struct PlusThreeCircle: View {
    var body: some View {
        Circle()
            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            .frame(width: 24, height: 24)
            .background(Circle().fill(Color.white))
            .overlay(
                Text("+3")
                    .font(Theme.Typography.smallBody)
                    .foregroundColor(Theme.Typography.smallBodyColor)
            )
    }
}
