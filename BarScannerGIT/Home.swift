//
//  Home.swift
//  BarScannerGIT
//
//  Created by Max de Castro on 1/1/25.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Color.clear.frame(height: 8)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Recommendations")
                    .font(.title)
                    .bold()
                
                Text("Recent product categories")
                    .font(Theme.Typography.smallerTitle)
                    .foregroundColor(.secondary)
            }
            
            TextCarouselView()
            
            Text("See our top choices")
                .font(Theme.Typography.smallerTitle)
                .foregroundColor(.secondary)
            
            ParallaxCarouselView()
                .frame(height: 320)
            
            Color.clear.frame(height: 34)
        }
        .padding()
    }
}

