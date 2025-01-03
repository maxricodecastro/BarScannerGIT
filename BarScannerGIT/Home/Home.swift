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
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recommendations")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent product categories")
                            .font(.system(size: 20))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 20)
                        
                        TextCarouselView()
                    }
                    
                    
                }
                .padding(.top, 20)
                
                

               
                VStack(alignment: .leading, spacing: 12) {
                    Text("See our top choices")
                        .font(.system(size: 20))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 20)
                    
                    ParallaxCarouselView()
                        .frame(height: 320)
                }
                
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


