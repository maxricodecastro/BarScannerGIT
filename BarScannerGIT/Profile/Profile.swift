import SwiftUI

struct GlassmorphicButton: View {
    let textColor: Color
    var action: () -> Void
    
    init(textColor: Color = .blue, 
         action: @escaping () -> Void) {
        self.textColor = textColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text("Share Thumbsy")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color(hex: "02B677"))
                .padding(.vertical, 8)
        }
    }
}

struct AboutSection: View {
    let isExpanded: Binding<Bool>
    
    var body: some View {
        DisclosureGroup(isExpanded: isExpanded) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Thumbsy is your smart shopping companion that brings together reviews from across the internet.\n\nWe cut through the noise so you can find the best products, faster.")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            }
        } label: {
            Text("About Us")
                .font(.system(size: 17))
                .foregroundColor(.primary)
        }
        .accentColor(.gray)
        .padding(.vertical, 12)
    }
}

struct FAQsSection: View {
    let isExpanded: Binding<Bool>
    
    var body: some View {
        DisclosureGroup(isExpanded: isExpanded) {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("How does Thumbsy work?")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Thumbsy aggregates product reviews from across the internet, making it easy to see what real customers think. Simply scan a product's barcode or search for an item to see consolidated reviews and ratings.")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Is Thumbsy free to use?")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Yes! Thumbsy is completely free. We believe everyone should have access to reliable product information.")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("How do I get started?")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Just open the app and scan any product's barcode. Instantly see aggregated reviews, ratings, and product information to help you make informed shopping decisions.")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
        } label: {
            Text("FAQs")
                .font(.system(size: 17))
                .foregroundColor(.primary)
        }
        .accentColor(.gray)
        .padding(.vertical, 12)
    }
}

struct ContactSection: View {
    let isExpanded: Binding<Bool>
    
    var body: some View {
        DisclosureGroup(isExpanded: isExpanded) {
            VStack(alignment: .leading, spacing: 16) {
                Text("thumbsy-app@gmail.com")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            }
        } label: {
            Text("Contact Us")
                .font(.system(size: 17))
                .foregroundColor(.primary)
        }
        .accentColor(.gray)
        .padding(.vertical, 12)
    }
}


struct Profile: View {
    @State private var openSection: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Title Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Settings")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.primary)
                    
                    Text("Customize Thumbsy")
                        .font(.system(size: 20))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 32)
                .padding(.top, 8)
                
                // Settings Sections
                VStack(spacing: 0) {
                    AboutSection(isExpanded: Binding(
                        get: { openSection == "about" },
                        set: { if $0 { openSection = "about" } else { openSection = nil } }
                    ))
                    
                    Divider()
                    
                    FAQsSection(isExpanded: Binding(
                        get: { openSection == "faqs" },
                        set: { if $0 { openSection = "faqs" } else { openSection = nil } }
                    ))
                    
                    Divider()
                    
                    ContactSection(isExpanded: Binding(
                        get: { openSection == "contact" },
                        set: { if $0 { openSection = "contact" } else { openSection = nil } }
                    ))
                }
                .padding(.horizontal, 32)
                
                MemberCard()
                    .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .environment(\.colorScheme, .light)
    }
}

struct MemberCard: View {
    var body: some View {
        ZStack {
            // Existing VStack with member info
            VStack(alignment: .leading, spacing: 4) {
                Text("Member since 2025")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Thanks for using Thumbsy to get all your reviews")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(width: 200, alignment: .leading)
                
                Spacer().frame(height: 12)  // Add some spacing before the button
                
                GlassmorphicButton(
                    textColor: Theme.companyColorGreen
                ) {
                    let shareText = "Check out Thumbsy! The best way to get reviews for your business."
                    let shareURL = URL(string: "https://www.thumbsy.net")!
                    
                    let activityVC = UIActivityViewController(
                        activityItems: [shareText, shareURL],
                        applicationActivities: nil
                    )
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootViewController = windowScene.windows.first?.rootViewController {
                        rootViewController.present(activityVC, animated: true)
                    }
                }
                .padding(.horizontal, 4)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 16)  // Reduced bottom padding
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
        }
        .background(
            ZStack {
                Image("thumb back")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .clipped()
                
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

struct FAQItem: View {
    let question: String
    let answer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
            
            Text(answer)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
        }
    }
}

struct HelpCenterItem: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
            
            Text(description)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    Profile()
}
