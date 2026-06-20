import Foundation

// Codable — gələcəkdə JSON API-dən parse edilə bilsin
// CaseIterable — UI-da bütün kateqoriyaları list kimi göstərə bilək
enum MuscleGroup: String, Codable, CaseIterable {
    case chest
    case back
    case shoulders
    case arms
    case legs
    case core
    case fullBody

    var displayName: String {
        switch self {
        case .chest:     return "Chest"
        case .back:      return "Back"
        case .shoulders: return "Shoulders"
        case .arms:      return "Arms"
        case .legs:      return "Legs"
        case .core:      return "Core"
        case .fullBody:  return "Full Body"
        }
    }

    var systemIcon: String {
        switch self {
        case .chest:     return "figure.strengthtraining.traditional"
        case .back:      return "figure.rowing"
        case .shoulders: return "figure.arms.open"
        case .arms:      return "figure.boxing"
        case .legs:      return "figure.run"
        case .core:      return "figure.core.training"
        case .fullBody:  return "figure.mixed.cardio"
        }
    }
}
