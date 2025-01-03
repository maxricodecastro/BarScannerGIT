import SwiftUI

struct SpiralCornersAnimation: View {
    // Customizable properties
    let initialCornerLength: CGFloat = 60
    let strokeWidth: CGFloat = 12
    let cornerRadius: CGFloat = 5
    let spiralRadius: CGFloat = 100
    let rotationSpeed: Double = 2.0
    
    @State private var retractProgress: CGFloat = 0
    @State private var spiralProgress: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let center = CGPoint(x: width/2, y: height/2)
            
            ZStack {
                CornerGroup(position: .topLeft,
                           size: CGSize(width: width, height: height),
                           center: center,
                           config: AnimationConfig(
                            initialLength: initialCornerLength,
                            strokeWidth: strokeWidth,
                            cornerRadius: cornerRadius,
                            retractProgress: retractProgress,
                            spiralProgress: spiralProgress))
                
                CornerGroup(position: .topRight,
                           size: CGSize(width: width, height: height),
                           center: center,
                           config: AnimationConfig(
                            initialLength: initialCornerLength,
                            strokeWidth: strokeWidth,
                            cornerRadius: cornerRadius,
                            retractProgress: retractProgress,
                            spiralProgress: spiralProgress))
                
                CornerGroup(position: .bottomLeft,
                           size: CGSize(width: width, height: height),
                           center: center,
                           config: AnimationConfig(
                            initialLength: initialCornerLength,
                            strokeWidth: strokeWidth,
                            cornerRadius: cornerRadius,
                            retractProgress: retractProgress,
                            spiralProgress: spiralProgress))
                
                CornerGroup(position: .bottomRight,
                           size: CGSize(width: width, height: height),
                           center: center,
                           config: AnimationConfig(
                            initialLength: initialCornerLength,
                            strokeWidth: strokeWidth,
                            cornerRadius: cornerRadius,
                            retractProgress: retractProgress,
                            spiralProgress: spiralProgress))
            }
            .onAppear {
                startAnimation()
            }
        }
    }
    
    private func startAnimation() {
        withAnimation(Animation.easeInOut(duration: 0.3)) {
            retractProgress = 0.7
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(Animation.easeInOut(duration: rotationSpeed).repeatForever(autoreverses: true)) {
                spiralProgress = 1.0
            }
        }
    }
}

// MARK: - Supporting Types
struct AnimationConfig {
    let initialLength: CGFloat
    let strokeWidth: CGFloat
    let cornerRadius: CGFloat
    let retractProgress: CGFloat
    let spiralProgress: CGFloat
}

enum CornerPosition {
    case topLeft, topRight, bottomLeft, bottomRight
}

// MARK: - Corner Group Component
struct CornerGroup: View {
    let position: CornerPosition
    let size: CGSize
    let center: CGPoint
    let config: AnimationConfig
    
    private var cornerPoint: CGPoint {
        switch position {
        case .topLeft:
            return CGPoint(x: config.initialLength/2, y: config.initialLength/2)
        case .topRight:
            return CGPoint(x: size.width - config.initialLength/2, y: config.initialLength/2)
        case .bottomLeft:
            return CGPoint(x: config.initialLength/2, y: size.height - config.initialLength/2)
        case .bottomRight:
            return CGPoint(x: size.width - config.initialLength/2, y: size.height - config.initialLength/2)
        }
    }
    
    private var horizontalOffset: CGFloat {
        switch position {
        case .topLeft, .bottomLeft: return config.initialLength/4
        case .topRight, .bottomRight: return -config.initialLength/4
        }
    }
    
    private var verticalOffset: CGFloat {
        switch position {
        case .topLeft, .topRight: return config.initialLength/4
        case .bottomLeft, .bottomRight: return -config.initialLength/4
        }
    }
    
    var body: some View {
        Group {
            // Vertical line
            RoundedRectangle(cornerRadius: config.cornerRadius)
                .fill(Color.white)
                .frame(width: config.strokeWidth,
                       height: config.initialLength * (1 - config.retractProgress))
                .offset(x: 0, y: verticalOffset * (1 - config.retractProgress))
            
            // Horizontal line
            RoundedRectangle(cornerRadius: config.cornerRadius)
                .fill(Color.white)
                .frame(width: config.initialLength * (1 - config.retractProgress),
                       height: config.strokeWidth)
                .offset(x: horizontalOffset * (1 - config.retractProgress), y: 0)
        }
        .position(cornerPosition(corner: cornerPoint, progress: config.spiralProgress, center: center))
        .rotationEffect(.degrees(config.spiralProgress * 360))
    }
    
    private func cornerPosition(corner: CGPoint, progress: CGFloat, center: CGPoint) -> CGPoint {
        let spiralPos = spiralPosition(progress: progress, startPoint: corner, center: center)
        return CGPoint(
            x: corner.x + (spiralPos.x - corner.x) * progress,
            y: corner.y + (spiralPos.y - corner.y) * progress
        )
    }
    
    private func spiralPosition(progress: CGFloat, startPoint: CGPoint, center: CGPoint) -> CGPoint {
        if progress == 0 { return startPoint }
        
        let angle = progress * 2 * .pi
        let distance = (1 - progress) * 100 // Fixed spiral radius
        
        return CGPoint(
            x: center.x + distance * cos(angle),
            y: center.y + distance * sin(angle)
        )
    }
}

#Preview {
    ZStack {
        Color.black
        SpiralCornersAnimation()
            .frame(width: 300, height: 200)
    }
}
