import SwiftUI

// Bütün boşluqlar 4-ün qatıdır — vizual ardıcıllıq üçün
enum AppSpacing {
    static let xs:  CGFloat = 4
    static let sm:  CGFloat = 8
    static let md:  CGFloat = 16
    static let lg:  CGFloat = 24
    static let xl:  CGFloat = 32
    static let xxl: CGFloat = 48
}

// Künc radiusları
enum AppRadius {
    static let sm:   CGFloat = 8
    static let md:   CGFloat = 12
    static let lg:   CGFloat = 16
    static let xl:   CGFloat = 20
    static let pill: CGFloat = 100
}

// Kart kölgəsi
extension View {
    func cardShadow() -> some View {
        self.shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}
