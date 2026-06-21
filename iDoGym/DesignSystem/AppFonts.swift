import SwiftUI

enum AppFonts {

    // MARK: - Başlıqlar
    static let largeTitle  = Font.system(size: 34, weight: .bold)
    static let title       = Font.system(size: 24, weight: .bold)
    static let title2      = Font.system(size: 20, weight: .semibold)
    static let headline    = Font.system(size: 17, weight: .semibold)

    // MARK: - Mətn
    static let body        = Font.system(size: 16, weight: .regular)
    static let callout     = Font.system(size: 15, weight: .regular)
    static let subheadline = Font.system(size: 14, weight: .regular)
    static let caption     = Font.system(size: 12, weight: .regular)
    static let captionBold = Font.system(size: 12, weight: .semibold)

    // MARK: - Taymer
    static let timerLarge  = Font.system(size: 64, weight: .bold, design: .monospaced)
    static let timerMedium = Font.system(size: 40, weight: .semibold, design: .monospaced)

    // MARK: - Stat rəqəmləri (Stats ekranındakı böyük rəqəmlər)
    static let statNumber  = Font.system(size: 36, weight: .bold)
    static let statLabel   = Font.system(size: 12, weight: .medium)
}
