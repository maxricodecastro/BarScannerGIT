import SwiftUI

struct NoProductSheet: View {

    
    var body: some View {
        VStack(spacing: 4) {
            Text("No Product Found")
                .font(Theme.Typography.title)
                .foregroundColor(Theme.Typography.titleColor)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("This product is currently not in our database")
                .font(Theme.Typography.subtitle)
                .foregroundColor(Theme.Typography.subtitleColor)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: {
                // Action here
            }) {
                Text("Add product?")
                    .font(Theme.Typography.title)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width * 0.6) // 40% of screen width
                    .padding(.vertical, 12)
                    .background(Theme.companyColorGreen)
                    .cornerRadius(24)
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, UIScreen.main.bounds.width * 0.06)
        .padding(.vertical, 16)
    }
} 
