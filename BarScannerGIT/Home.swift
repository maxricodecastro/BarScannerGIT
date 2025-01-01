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
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recommendations")
                        .font(.title)
                        .bold()
                }
                 .padding(.top, 36) // Small top padding

                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent product categories")
                        .font(Theme.Typography.smallerTitle)
                        .foregroundColor(.secondary)

                        TextCarouselView()
                }
               
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("See our top choices")
                        .font(Theme.Typography.smallerTitle)
                        .foregroundColor(.secondary)
                    
                    ParallaxCarouselView()
                        .frame(height: 320)
                }
                
                Color.white.frame(height: 34)  // Bottom padding
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .environment(\.colorScheme, .light)
    }
}

