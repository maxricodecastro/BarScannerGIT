//
//  Home.swift
//  BarScannerGIT
//
//  Created by Max de Castro on 1/1/25.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recommendations")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.primary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 36)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent product categories")
                        .font(Theme.Typography.smallerTitle)
                        .foregroundColor(.secondary)

                    TextCarouselView()
                }
                .padding(.horizontal, 20)
               
                VStack(alignment: .leading, spacing: 12) {
                    Text("See our top choices")
                        .font(Theme.Typography.smallerTitle)
                        .foregroundColor(.secondary)
                    
                    ParallaxCarouselView()
                        .frame(height: 320)
                }
                .padding(.horizontal, 20)
                
                Color.white.frame(height: 34)  // Bottom padding
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .environment(\.colorScheme, .light)
    }
}

#Preview {
    HomePage()
}


