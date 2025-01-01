import SwiftUI

struct Search: View {
    @State private var searchText = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Search")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.primary)
                    
                    Text("Find products")
                        .font(.system(size: 20))
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 36)
                .padding(.horizontal)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search products...", text: $searchText)
                        .font(.body)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .opacity(0.7)
                        }
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal)
                
                Spacer()
                
                // Premium Feature Section
                VStack(spacing: 8) {
                    Image("thumbsytransparent")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64, height: 64)
                    
                    HStack(spacing: 8) {
                        Text("Premium feature")
                            .font(Theme.Typography.title)
                            .foregroundColor(Theme.Typography.titleColor)
                        
                        Text("🔒")
                            .font(.title2)
                    }
                    
                    Button(action: {
                        // Add unlock action here
                    }) {
                        Text("Unlock for $3.99")
                            .font(Theme.Typography.subtitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Theme.companyColorGreen)
                            )
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
                }
                .padding(.top, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .environment(\.colorScheme, .light)
    }
}

#Preview {
    Search()
}
