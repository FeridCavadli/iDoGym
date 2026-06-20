import Foundation
import SwiftData

@Model
final class ExerciseSet {

    @Attribute(.unique) var id: UUID

    var reps: Int           // təkrar sayı
    var weight: Double      // çəki (kg)
    var isCompleted: Bool   // istifadəçi bu set-i bitirdimi?
    var completedAt: Date?  // nə vaxt tamamlandı (statistika üçün gələcəkdə)

    // Hansı ExerciseLog-a aiddir — SwiftData inverse-i avtomatik idarə edir
    var exerciseLog: ExerciseLog?

    init(reps: Int = 0, weight: Double = 0) {
        self.id = UUID()
        self.reps = reps
        self.weight = weight
        self.isCompleted = false
        self.completedAt = nil
    }
}
