import Foundation
import SwiftData

final class LocalExerciseRepository: ExerciseRepositoryProtocol {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() async throws -> [Exercise] {
        let descriptor = FetchDescriptor<Exercise>(
            sortBy: [SortDescriptor(\.name)]
        )
        return try context.fetch(descriptor)
    }

    func save(_ exercise: Exercise) async throws {
        context.insert(exercise)
        try context.save()
    }

    func seedDefaultsIfNeeded() async throws {
        let existing = try await fetchAll()
        // Artıq məşqlər varsa seed etmə
        guard existing.isEmpty else { return }

        let defaults: [(String, MuscleGroup)] = [
            // Chest
            ("Bench Press", .chest),
            ("Incline Dumbbell Press", .chest),
            ("Cable Fly", .chest),
            ("Push-up", .chest),
            // Back
            ("Pull-up", .back),
            ("Barbell Row", .back),
            ("Lat Pulldown", .back),
            ("Seated Cable Row", .back),
            // Shoulders
            ("Overhead Press", .shoulders),
            ("Lateral Raise", .shoulders),
            ("Front Raise", .shoulders),
            // Arms
            ("Bicep Curl", .arms),
            ("Hammer Curl", .arms),
            ("Tricep Pushdown", .arms),
            ("Skull Crusher", .arms),
            // Legs
            ("Squat", .legs),
            ("Romanian Deadlift", .legs),
            ("Leg Press", .legs),
            ("Leg Curl", .legs),
            ("Calf Raise", .legs),
            // Core
            ("Plank", .core),
            ("Ab Rollout", .core),
            ("Crunch", .core),
        ]

        for (name, group) in defaults {
            context.insert(Exercise(name: name, muscleGroup: group))
        }
        try context.save()
    }
}
