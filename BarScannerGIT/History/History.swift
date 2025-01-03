import SwiftUI

struct History: View {
    let productList = ProductList.sampleList
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(productList.title)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.primary)
                    
                    Text(productList.subtitle)
                        .font(.system(size: 20))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // List items
                VStack(spacing: 20) {
                    ForEach(productList.items) { item in
                        ProductListItemView(item: item)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .background(Color.white)
        .environment(\.colorScheme, .light)
    }
}

struct ProductListItemView: View {
    let item: ProductList.ProductListItem
    
    var body: some View {
        HStack(spacing: 16) {
            // Image
            Image(item.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Text content
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text(item.subtitle)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            // Handle tap action
        }
    }
}

#Preview {
    History()
}
