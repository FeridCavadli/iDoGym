import Foundation
import SwiftData

// @Model — SwiftData bu class-ı avtomatik olaraq bazaya yazmağı bacarır
// final — override edilməsin (performans + dizayn aydınlığı)
@Model
final class Exercise {

    // @Attribute(.unique) — eyni id-li iki Exercise yarana bilməz
    // Gələcəkdə API-dən gələn məşqlərlə birləşdirmək üçün vacibdir
    @Attribute(.unique) var id: UUID

    var name: String
    var muscleGroup: MuscleGroup
    var notes: String
    var createdAt: Date

    // Geri istinad: bu məşq hansı workout-larda istifadə olunub?
    // deleteRule yoxdur — Exercise silinəndə keçmiş workout tarixçəsi silinməməlidir
    @Relationship var logs: [ExerciseLog] = []

    init(name: String, muscleGroup: MuscleGroup, notes: String = "") {
        self.id = UUID()
        self.name = name
        self.muscleGroup = muscleGroup
        self.notes = notes
        self.createdAt = Date()
    }
}
