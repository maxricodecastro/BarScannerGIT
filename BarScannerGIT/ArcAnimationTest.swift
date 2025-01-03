import SwiftUI

struct CornerMask: Shape {
    let cornerSize: CGFloat = 40
    let inset: CGFloat = 12
    let pathProgress: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Define the corner positions
        let corners = [
            CGPoint(x: inset, y: inset),                          // Top Left
            CGPoint(x: width - inset, y: inset),                  // Top Right
            CGPoint(x: width - inset, y: height - inset),         // Bottom Right
            CGPoint(x: inset, y: height - inset)                  // Bottom Left
        ]
        
        let perimeter = 2 * (width + height - 2 * inset)
        
        // Calculate positions for each frame
        for i in 0..<4 {
            let position: CGPoint
            if pathProgress == 0 {
                position = corners[i]
            } else {
                let frameProgress = (pathProgress + CGFloat(i) * 0.25)
                    .truncatingRemainder(dividingBy: 1.0)
                position = smoothPositionOnPath(progress: frameProgress, rect: rect)
            }
            
            path.addRect(CGRect(
                x: position.x - cornerSize/2,
                y: position.y - cornerSize/2,
                width: cornerSize,
                height: cornerSize
            ))
        }
        
        return path
    }
    
    private func smoothPositionOnPath(progress: CGFloat, rect: CGRect) -> CGPoint {
        let width = rect.width - 2 * inset
        let height = rect.height - 2 * inset
        let totalLength = 2 * (width + height)
        let position = progress * totalLength
        
        // Calculate normalized position (0 to 1) within current segment
        func normalize(_ pos: CGFloat, in length: CGFloat) -> CGFloat {
            return pos / length
        }
        
        if position < width {
            // Top edge
            return CGPoint(x: inset + position, y: inset)
        } else if position < width + height {
            // Right edge
            let y = position - width
            return CGPoint(x: rect.width - inset, y: inset + y)
        } else if position < 2 * width + height {
            // Bottom edge
            let x = position - (width + height)
            return CGPoint(x: rect.width - inset - x, y: rect.height - inset)
        } else {
            // Left edge
            let y = position - (2 * width + height)
            return CGPoint(x: inset, y: rect.height - inset - y)
        }
    }
}

struct ArcAnimationTest: View {
    @State private var pathProgress: CGFloat = 0
    @State private var isAnimating = false
    @State private var animationSpeed: Double = 2.0
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white, lineWidth: 5)
                .frame(width: 280, height: 180)
                .mask {
                    CornerMask(pathProgress: pathProgress)
                }
            
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Position")
                    Slider(value: $pathProgress, in: 0...1)
                        .disabled(isAnimating)
                }
                
                VStack(alignment: .leading) {
                    Text("Speed: \(String(format: "%.1f", animationSpeed))x")
                    Slider(value: $animationSpeed, in: 0.5...4.0)
                        .onChange(of: animationSpeed) { _ in
                            if isAnimating {
                                startAnimation()
                            }
                        }
                }
                
                Button(isAnimating ? "Stop" : "Start") {
                    if isAnimating {
                        isAnimating = false
                    } else {
                        startAnimation()
                    }
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .foregroundColor(.white)
            .padding()
        }
    }
    
    private func startAnimation() {
        isAnimating = true
        withAnimation(.linear(duration: 2/animationSpeed).repeatForever(autoreverses: false)) {
            pathProgress = 1.0
        }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        ArcAnimationTest()
    }
} 
