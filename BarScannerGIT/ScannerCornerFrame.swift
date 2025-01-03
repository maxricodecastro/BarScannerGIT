//import SwiftUI
//
//struct ArcShape: Shape {
//    func path(in rect: CGRect) -> Path {
//        let radius = min(rect.width, rect.height) / 2
//        let center = CGPoint(x: rect.midX, y: rect.midY)
//        
//        var path = Path()
//        path.addArc(
//            center: center,
//            radius: radius,
//            startAngle: .degrees(-90),
//            endAngle: .degrees(0),
//            clockwise: false
//        )
//        return path
//    }
//}
//
//struct CornerArcView: View {
//    let position: Corner
//    
//    enum Corner {
//        case topLeft, topRight, bottomLeft, bottomRight
//        
//        var rotation: Double {
//            switch self {
//            case .topLeft: return -90
//            case .topRight: return 0
//            case .bottomLeft: return 180
//            case .bottomRight: return 90
//            }
//        }
//    }
//    
//    var body: some View {
//        ArcShape()
//            .stroke(
//                Color.white,
//                style: StrokeStyle(lineWidth: 8, lineCap: .round)
//            )
//            .frame(width: 60, height: 60)
//            .rotationEffect(.degrees(position.rotation))
//    }
//}
//
//struct QuadArcView: View {
//    // Rectangle dimensions
//    let frameWidth: CGFloat = 280
//    let frameHeight: CGFloat = 180
//    
//    var body: some View {
//        ZStack {
//            // Top Left Corner
//            CornerArcView(position: .topLeft)
//                .position(x: 40, y: 40)
//            
//            // Top Right Corner
//            CornerArcView(position: .topRight)
//                .position(x: frameWidth - 40, y: 40)
//            
//            // Bottom Left Corner
//            CornerArcView(position: .bottomLeft)
//                .position(x: 40, y: frameHeight - 40)
//            
//            // Bottom Right Corner
//            CornerArcView(position: .bottomRight)
//                .position(x: frameWidth - 40, y: frameHeight - 40)
//        }
//        .frame(width: frameWidth, height: frameHeight)
//    }
//}
//
//#Preview {
//    ZStack {
//        Color.black
//            .ignoresSafeArea()
//        QuadArcView()
//    }
//}
