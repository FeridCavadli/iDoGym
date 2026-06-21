import SwiftUI

enum AppColors {

    // MARK: - Backgrounds
    static let background        = Color(hex: "#F2F2F7")  // açıq boz sistem fonu
    static let surface           = Color.white             // kart fonu
    static let surfaceSecondary  = Color(hex: "#F2F2F7")  // ikinci səviyyə fon

    // MARK: - Brand
    static let primary   = Color(hex: "#0058BC")  // mavi — əsas aksent (Figma-dan)
    static let secondary = Color(hex: "#3B82F6")  // açıq mavi — ikinci aksent

    // MARK: - Text
    static let textPrimary   = Color(hex: "#1A1B1F")  // demək olar qara
    static let textSecondary = Color(hex: "#414755")  // boz
    static let textTertiary  = Color(hex: "#717786")  // açıq boz

    // MARK: - Status
    static let success = Color(hex: "#22C55E")  // yaşıl
    static let warning = Color(hex: "#F59E0B")  // narıncı
    static let danger  = Color(hex: "#EF4444")  // qırmızı

    // MARK: - Timer
    static let timerWork = Color(hex: "#2563EB")  // iş vaxtı — mavi
    static let timerRest = Color(hex: "#22C55E")  // dincəlmə — yaşıl

    // MARK: - Tab Bar
    static let tabActive   = Color(hex: "#2563EB")
    static let tabInactive = Color(hex: "#94A3B8")
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
