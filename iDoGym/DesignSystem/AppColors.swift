import SwiftUI

enum AppColors {

    // MARK: - Backgrounds
    static let background       = Color(hex: "#0D0D0D")  // əsas qara fon
    static let surface          = Color(hex: "#1C1C1E")  // kart/panel fonu
    static let surfaceSecondary = Color(hex: "#2C2C2E")  // ikinci səviyyə panel

    // MARK: - Brand
    static let primary   = Color(hex: "#F5C518")  // amber sarı — əsas aksent (Set Goal düyməsi)
    static let secondary = Color(hex: "#3DD9C5")  // teal — məşq ekranı aksenti

    // MARK: - Text
    static let textPrimary   = Color.white
    static let textSecondary = Color(hex: "#8E8E93")
    static let textTertiary  = Color(hex: "#48484A")

    // MARK: - Status
    static let success = Color(hex: "#30D158")  // tamamlandı
    static let danger  = Color(hex: "#FF3B30")  // sil / xəbərdarlıq

    // MARK: - Timer
    static let timerActive = Color(hex: "#FF2D00")  // aktiv taymer — qırmızı LED
    static let timerRest   = Color(hex: "#3DD9C5")  // dincəlmə taymeri — teal
}

// MARK: - Hex dəstəyi
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
