import Foundation

@Observable
final class ExercisePickerViewModel {

    var exercises: [Exercise] = []
    var selectedMuscleGroup: MuscleGroup? = nil  // nil = hamısını göstər

    private let exerciseRepository: ExerciseRepositoryProtocol
    private let workoutRepository: WorkoutRepositoryProtocol

    init(
        exerciseRepository: ExerciseRepositoryProtocol,
        workoutRepository: WorkoutRepositoryProtocol
    ) {
        self.exerciseRepository = exerciseRepository
        self.workoutRepository = workoutRepository
    }

    // Seçilmiş kateqoriyaya görə filterləmə
    var filteredExercises: [Exercise] {
        guard let group = selectedMuscleGroup else { return exercises }
        return exercises.filter { $0.muscleGroup == group }
    }

    func load() async {
        do {
            try await exerciseRepository.seedDefaultsIfNeeded()
            exercises = try await exerciseRepository.fetchAll()
        } catch { }
    }

    // Seçilən məşqi workout-a əlavə et
    func addExercise(_ exercise: Exercise, to workout: Workout) async {
        let log = ExerciseLog(order: workout.exercises.count)
        log.exercise = exercise
        log.workout = workout
        workout.exercises.append(log)

        // Default olaraq 3 boş set yarat
        for _ in 0..<3 {
            let set = ExerciseSet(reps: 10, weight: 0)
            set.exerciseLog = log
            log.sets.append(set)
        }

        try? await workoutRepository.save(workout)
    }
}
