import Foundation
import SwiftData

@Model
final class Workout {

    @Attribute(.unique) var id: UUID

    var name: String        // məs. "Chest Day", "Push A"
    var date: Date
    var notes: String
    var isCompleted: Bool

    // deleteRule: .cascade — Workout silinəndə bütün ExerciseLog-lar (və onların set-ləri) də silinsin
    @Relationship(deleteRule: .cascade)
    var exercises: [ExerciseLog] = []

    init(name: String, date: Date = Date(), notes: String = "") {
        self.id = UUID()
        self.name = name
        self.date = date
        self.notes = notes
        self.isCompleted = false
    }

    // Hesablanmış property-lər — bazaya yazılmır, hər dəfə hesablanır
    var totalSets: Int {
        exercises.reduce(0) { $0 + $1.sets.count }
    }

    var completedSets: Int {
        exercises.reduce(0) { $0 + $1.sets.filter(\.isCompleted).count }
    }

    // İrəliləmə faizi (0.0 — 1.0) — progress bar üçün gələcəkdə
    var progress: Double {
        guard totalSets > 0 else { return 0 }
        return Double(completedSets) / Double(totalSets)
    }
}
