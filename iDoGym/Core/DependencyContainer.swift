import Foundation
import SwiftData

// @Observable — SwiftUI bu class-ı izləyə bilsin (dəyişiklik olsa UI yenilənsin)
@Observable
final class DependencyContainer {

    // ViewModel-lər bu property-ə çatır — protokol tipi, konkret class deyil
    let workoutRepository: WorkoutRepositoryProtocol

    init(modelContext: ModelContext) {
        // Burada qərara alınır: hansı implementasiya işləsin
        // Gələcəkdə: self.workoutRepository = APIWorkoutRepository(...)
        self.workoutRepository = LocalWorkoutRepository(context: modelContext)
    }
}
