import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            TabBarButton(imageName: "house.fill", text: "Home", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            
            Spacer()
            
            TabBarButton(imageName: "magnifyingglass", text: "Search", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            
            Spacer()
            
            TabBarButton(imageName: "camera.fill", text: "Scan", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
            
            Spacer()
            
            TabBarButton(imageName: "bell.fill", text: "Notifications", isSelected: selectedTab == 3) {
                selectedTab = 3
            }
            
            Spacer()
            
            TabBarButton(imageName: "person.fill", text: "Profile", isSelected: selectedTab == 4) {
                selectedTab = 4
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Theme.background)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Theme.border),
            alignment: .top
        )
    }
}

struct TabBarButton: View {
    let imageName: String
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text(text)
                    .font(.system(size: 12))
            }
        }
        .foregroundColor(isSelected ? Theme.primary : Theme.secondaryText)
    }
}

