import SwiftUI

struct CircleButton: View {
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background {
                    Circle()
                        .fill(.white.opacity(0.2))
                        .background {
                            Circle()
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        }
                        .blur(radius: 10)
                }
                .background {
                    Circle()
                        .fill(.ultraThinMaterial)
                }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        CircleButton(iconName: "arrow.up.right") {
            print("Button tapped")
        }
    }
} 