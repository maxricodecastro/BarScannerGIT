import SwiftUI

struct CustomBottomSheet: View {
    @Binding var isPresented: Bool
    @State private var currentHeight: CGFloat = UIScreen.main.bounds.height * 0.5 // Start at 50%
    @State private var dragOffset: CGFloat = 0

    let collapsedHeight: CGFloat = UIScreen.main.bounds.height * 0.5
    let expandedHeight: CGFloat = UIScreen.main.bounds.height * 0.7

    // Placeholder for rating (out of 5)
    let rating: Int = 4

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer() // Pushes the sheet to the bottom

                ZStack(alignment: .topLeading) {
                    // Bottom Sheet Content
                    VStack {
                        // Pull Handle
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Theme.secondaryText)
                            .frame(width: 50, height: 5)
                            .padding(.top, 10)

                        Spacer() // Ensure other content fits dynamically
                    }
                    .frame(height: currentHeight + dragOffset) // Adjust height dynamically
                    .frame(maxWidth: .infinity)
                    .background(Theme.background)
                    .cornerRadius(20)
                    .shadow(radius: 10)

                    // Circle with Default Image
                    Circle()
                        .stroke(Theme.text, lineWidth: 1)
                        .frame(width: 64, height: 64)
                        .background(
                            Image(systemName: "person.circle.fill") // Placeholder image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                        )
                        .padding(.top, 16) // Space from the top of the sheet
                        .padding(.leading, 16) // Space from the left of the sheet

                    // Product Title Text
                    Text("Product Title")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Theme.text)
                        .padding(.top, 24) // Adjust top position as needed
                        .padding(.leading, 96) // Adjust left position as needed
                    
                    // Product Subtitle and Review Stars
                    HStack(spacing: 8) { // Adjust spacing here
                        Text("$299")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Theme.secondaryText)

                        HStack(spacing: 4) { // Control star spacing here
                            ForEach(0..<5) { index in
                                Image(systemName: index < rating ? "star.fill" : "star")
                                    .resizable()
                                    .foregroundColor(index < rating ? Theme.star : Theme.secondaryText)
                                    .frame(width: 16, height: 16) // Adjust size here
                            }
                        }
                    }
                    .padding(.top, 56) // Adjust vertical position here
                    .padding(.leading, 96) // Align with product title and circle
                    
                    
                    // Bookmark Icon
                    Image(systemName: "bookmark")
                        .resizable()
                        .foregroundColor(Theme.secondaryText)
                        .frame(width: 24, height: 32) // Adjust size as needed
                        .padding(.top, 24) // Space from the top of the sheet
                        .padding(.trailing, 24) // Space from the right of the sheet
                        .frame(maxWidth: .infinity, alignment: .topTrailing) // Align to the top-right

                    // Carousel for Articles
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(0..<3) { _ in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 4) {
                                        Circle()
                                            .frame(width: 12, height: 12)
                                            .foregroundColor(Theme.primary)
                                        Text("Wired")
                                            .font(.system(size: 12))
                                            .foregroundColor(Theme.secondaryText)
                                    }

                                    Text("The best VR headsets of 2024")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(.black)

                                    Text("18 days ago")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Theme.background)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.top, 96) // Space below product subtitle
                        .padding(.leading, 0) // Align with title and subtitle
                    }
                    
                    //review sources

                        // Main Rectangle with Icon and Label
                        HStack(spacing: 4) { // Spacing between icon and label
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundColor(Theme.secondaryText)
                            
                            Text("Amazon")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.secondaryText)

                            // Add additional circles to the right of Amazon label
                            HStack(spacing: -4) { // Negative spacing for overlap
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 12, height: 12)
                                
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 12, height: 12)

                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 12, height: 12)
                        }
                        .padding(.horizontal, 8) // Padding inside the rectangle
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.border, lineWidth: 1)
                                .background(Theme.background)
                                .cornerRadius(12)
                        )
                    }
                    .padding(.top, 80) // Adjust vertical position
                    .padding(.trailing, 200) // Adjust horizontal position
                    .frame(maxWidth: .infinity, alignment: .topTrailing) // Align to the top-right
                    
                    
                    // Description Title
                    Text("Description")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.text)
                        .padding(.top, 200) // Moved down by 164px
                        .padding(.leading, 16)
                        .padding(.trailing, 16)

                    // Short Description
                    Text("The iPhone combines elegant design with cutting-edge technology. Featuring an intuitive interface, lightning-fast performance, and seamless integration across devices, it's perfect for productivity, creativity, and staying connected.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Theme.secondaryText)
                        .padding(.top, 226) // Moved down by 164px
                        .padding(.leading, 16)
                        .padding(.trailing, 16)

                    // Circle with Rating Number
                    Circle()
                        .fill(Theme.success.opacity(0.5))
                        .frame(width: 48, height: 48)
                        .overlay(
                            Text("7.2")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .padding(.top, 364) // Moved down by 164px
                        .padding(.leading, 16)

                    // Company Name Text
                    Text("Company Name")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 368) // Moved down by 164px
                        .padding(.leading, 72)

                    // Company Subtitle Text
                    Text("Company Subtitle")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                        .padding(.top, 392) // Moved down by 164px
                        .padding(.leading, 72)

                    // Warning Icon
                    Circle()
                        .fill(Theme.warning.opacity(0.3))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Text("!")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .padding(.top, 364) // Moved down by 164px
                        .padding(.trailing, 16) // Space from the right
                        .frame(maxWidth: .infinity, alignment: .topTrailing) // Align to the top-right
                }
                .offset(y: isPresented ? 0 : geometry.size.height) // Slide in/out animation
                .animation(.spring(), value: isPresented)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // Update the drag offset as the user drags
                            let newHeight = currentHeight - value.translation.height
                            if newHeight >= collapsedHeight && newHeight <= expandedHeight {
                                dragOffset = -value.translation.height
                            }
                        }
                        .onEnded { value in
                            // If the user drags below the collapsed height, dismiss
                            let finalHeight = currentHeight + dragOffset
                            if finalHeight < collapsedHeight {
                                isPresented = false
                                // Reset so that next open starts fresh
                                currentHeight = collapsedHeight
                                dragOffset = 0
                                return
                            }
                            // Snap to the nearest height (collapsed or expanded)
                            if currentHeight + dragOffset > (collapsedHeight + expandedHeight) / 2 {
                                currentHeight = expandedHeight
                            } else {
                                currentHeight = collapsedHeight
                            }
                            dragOffset = 0 // Reset drag offset
                        }
                )
            }
        }
    }
}

