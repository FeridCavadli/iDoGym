import SwiftUI

enum AppFonts {

    // MARK: - Başlıqlar
    static let largeTitle  = Font.system(size: 34, weight: .bold)
    static let title       = Font.system(size: 28, weight: .bold)
    static let title2      = Font.system(size: 22, weight: .semibold)
    static let headline    = Font.system(size: 17, weight: .semibold)

    // MARK: - Mətn
    static let body        = Font.system(size: 17, weight: .regular)
    static let callout     = Font.system(size: 16, weight: .regular)
    static let subheadline = Font.system(size: 15, weight: .regular)
    static let caption     = Font.system(size: 12, weight: .regular)
    static let caption2    = Font.system(size: 11, weight: .regular)

    // MARK: - Taymer (LED/rəqəmsal üslub)
    // design: .monospaced — rəqəmlər eyni genişlikdə olsun, titrəməsin
    static let timerLarge  = Font.system(size: 80, weight: .thin,   design: .monospaced)
    static let timerMedium = Font.system(size: 48, weight: .light,  design: .monospaced)
    static let timerSmall  = Font.system(size: 28, weight: .regular, design: .monospaced)

    // MARK: - Set sıraları (Image 2-dəki "60kg", "10reps" üslubu)
    static let setNumber   = Font.system(size: 28, weight: .bold)
    static let setLabel    = Font.system(size: 13, weight: .regular)
}
