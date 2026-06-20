import Foundation
import SwiftData

@Observable
final class DependencyContainer {

    let workoutRepository: WorkoutRepositoryProtocol
    let exerciseRepository: ExerciseRepositoryProtocol

    init(modelContext: ModelContext) {
        self.workoutRepository = LocalWorkoutRepository(context: modelContext)
        self.exerciseRepository = LocalExerciseRepository(context: modelContext)
    }
}
