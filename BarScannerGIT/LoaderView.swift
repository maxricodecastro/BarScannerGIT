import SwiftUI

struct LoaderView: View {
    @State private var isExpanding = false
    @State private var isRetracting = false
    @State private var circleOpacity = 1.0
    @State private var lineOpacity = 0.0
    @State private var isAnimating = false
    @State private var shouldComplete = false
    
    let onAnimationComplete: () -> Void
    
    private var width: CGFloat {
        UIScreen.main.bounds.width * 0.6
    }
    
    private var height: CGFloat {
        UIScreen.main.bounds.width * 0.36
    }
    
    var body: some View {
        ZStack {
            // Lines
            Group {
                // Top Line
                RoundedRectangle(cornerRadius: 6)
                    .fill(.white)
                    .frame(width: expandWidth, height: 10)
                    .offset(x: topLineOffset, y: -height/2 + 5)
                
                // Right Line
                RoundedRectangle(cornerRadius: 6)
                    .fill(.white)
                    .frame(width: 10, height: expandHeight)
                    .offset(x: width/2 - 5, y: rightLineOffset)
                
                // Bottom Line
                RoundedRectangle(cornerRadius: 6)
                    .fill(.white)
                    .frame(width: expandWidth, height: 10)
                    .offset(x: bottomLineOffset, y: height/2 - 5)
                
                // Left Line
                RoundedRectangle(cornerRadius: 6)
                    .fill(.white)
                    .frame(width: 10, height: expandHeight)
                    .offset(x: -width/2 + 5, y: leftLineOffset)
            }
            .opacity(lineOpacity)
            
            // Corner circles
            Group {
                // Top-left
                RoundedRectangle(cornerRadius: 6)
                    .fill(.white)
                    .frame(width: 10, height: 10)
                    .offset(x: -width/2 + 5, y: -height/2 + 5)
                    .scaleEffect(circleScale)
                
                // Top-right
                RoundedRectangle(cornerRadius: 6)
                    .fill(.white)
                    .frame(width: 10, height: 10)
                    .offset(x: width/2 - 5, y: -height/2 + 5)
                    .scaleEffect(circleScale)
                
                // Bottom-right
                RoundedRectangle(cornerRadius: 6)
                    .fill(.white)
                    .frame(width: 10, height: 10)
                    .offset(x: width/2 - 5, y: height/2 - 5)
                    .scaleEffect(circleScale)
                
                // Bottom-left
                RoundedRectangle(cornerRadius: 6)
                    .fill(.white)
                    .frame(width: 10, height: 10)
                    .offset(x: -width/2 + 5, y: height/2 - 5)
                    .scaleEffect(circleScale)
            }
            .opacity(circleOpacity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            isAnimating = true
            animate()
        }
    }
    
    private var circleScale: CGFloat {
        isExpanding ? 0.8 : 1.0
    }
    
    private var expandWidth: CGFloat {
        if isExpanding {
            return width
        } else if isRetracting {
            return 10
        } else {
            return 10
        }
    }
    
    private var expandHeight: CGFloat {
        if isExpanding {
            return height
        } else if isRetracting {
            return 10
        } else {
            return 10
        }
    }
    
    private var topLineOffset: CGFloat {
        if isExpanding {
            return 0
        } else if isRetracting {
            return width/2 - 5
        } else {
            return -width/2 + 5
        }
    }
    
    private var rightLineOffset: CGFloat {
        if isExpanding {
            return 0
        } else if isRetracting {
            return height/2 - 5
        } else {
            return -height/2 + 5
        }
    }
    
    private var bottomLineOffset: CGFloat {
        if isExpanding {
            return 0
        } else if isRetracting {
            return -width/2 + 5
        } else {
            return width/2 - 5
        }
    }
    
    private var leftLineOffset: CGFloat {
        if isExpanding {
            return 0
        } else if isRetracting {
            return -height/2 + 5
        } else {
            return height/2 - 5
        }
    }
    
    private func animate() {
        let expandDuration = 0.3
        let retractDuration = 0.25
        let transitionDuration = 0.2
        let pauseDuration = 0.1
        
        // Reset states if needed
        if !isAnimating {
            isExpanding = false
            isRetracting = false
            circleOpacity = 1
            lineOpacity = 0
            return
        }
        
        // Quick fade and start expansion
        withAnimation(.easeOut(duration: transitionDuration)) {
            circleOpacity = 0
            lineOpacity = 1
        }
        
        // Snappy expansion
        withAnimation(.easeOut(duration: expandDuration).delay(transitionDuration)) {
            isExpanding = true
        }
        
        // Retract after a brief pause
        DispatchQueue.main.asyncAfter(deadline: .now() + expandDuration + transitionDuration + pauseDuration) {
            withAnimation(.easeIn(duration: retractDuration)) {
                isRetracting = true
                isExpanding = false
            }
            
            // Quick transition back to circles
            DispatchQueue.main.asyncAfter(deadline: .now() + retractDuration) {
                withAnimation(.easeOut(duration: transitionDuration)) {
                    lineOpacity = 0
                    circleOpacity = 1
                }
                
                isRetracting = false
                
                // Check if we should complete or continue
                if shouldComplete {
                    isAnimating = false
                    onAnimationComplete()
                } else {
                    // Continue animation with a brief pause
                    DispatchQueue.main.asyncAfter(deadline: .now() + transitionDuration + 0.2) {
                        if isAnimating {
                            animate()
                        }
                    }
                }
            }
        }
    }
    
    // Make this method public
    func completeAnimation() {
        shouldComplete = true
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        
        LoaderView(onAnimationComplete: {
            // Preview completion handler
            print("Animation completed")
        })
    }
} 

