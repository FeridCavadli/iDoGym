import Foundation
import SwiftData

// Bu class "körpü" rolunu oynayır:
// Bir workout-da edilən konkret məşqin qeydi — hansı məşq şablonu + neçə set
@Model
final class ExerciseLog {

    @Attribute(.unique) var id: UUID

    // Workout içindəki sıra (1-ci məşq, 2-ci məşq...)
    var order: Int
    // Setlər arası fasilə müddəti (saniyə) — ActiveWorkout-da istifadə olunur
    var restDuration: Int = 60

    // Hansı workout-a aiddir
    var workout: Workout?
    // Hansı məşq şablonundan istifadə olunub (Exercise kitabxanasından)
    var exercise: Exercise?

    // deleteRule: .cascade — ExerciseLog silinəndə onun set-ləri də silinsin
    @Relationship(deleteRule: .cascade)
    var sets: [ExerciseSet] = []

    init(order: Int) {
        self.id = UUID()
        self.order = order
    }
}
