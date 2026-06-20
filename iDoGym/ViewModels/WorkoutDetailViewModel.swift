import Foundation

@Observable
final class WorkoutDetailViewModel {

    let workout: Workout
    private let repository: WorkoutRepositoryProtocol

    init(workout: Workout, repository: WorkoutRepositoryProtocol) {
        self.workout = workout
        self.repository = repository
    }

    // Məşqləri sıraya görə düzülmüş qaytarır
    var sortedExercises: [ExerciseLog] {
        workout.exercises.sorted { $0.order < $1.order }
    }

    func addSet(to log: ExerciseLog) async {
        // Son setin dəyərlərini kopyala — istifadəçi adətən eyni çəki ilə davam edir
        let lastSet = log.sets.last
        let newSet = ExerciseSet(
            reps: lastSet?.reps ?? 10,
            weight: lastSet?.weight ?? 0
        )
        log.sets.append(newSet)
        try? await repository.save(workout)
    }

    func toggleCompletion(_ set: ExerciseSet) async {
        set.isCompleted.toggle()
        set.completedAt = set.isCompleted ? Date() : nil
        try? await repository.save(workout)
    }

    func deleteSet(_ set: ExerciseSet, from log: ExerciseLog) async {
        log.sets.removeAll { $0.id == set.id }
        try? await repository.save(workout)
    }
}
