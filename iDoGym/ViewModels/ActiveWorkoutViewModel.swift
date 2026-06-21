import Foundation

@Observable
final class ActiveWorkoutViewModel {

    enum WorkPhase: Equatable {
        case working   // set edilir
        case resting   // sets arası dincəlmə
        case done      // bütün workout bitdi
    }

    let workout: Workout
    private let repository: WorkoutRepositoryProtocol

    let timer = TimerService()

    private(set) var currentExerciseIndex = 0
    private(set) var currentSetIndex = 0
    private(set) var workPhase: WorkPhase = .working

    private let defaultRestDuration: TimeInterval = 60

    init(workout: Workout, repository: WorkoutRepositoryProtocol) {
        self.workout = workout
        self.repository = repository
        timer.startCountup()  // ekran açılınca set taymeri başlayır
    }

    // MARK: - Hesablanmış məlumatlar

    private var sortedExercises: [ExerciseLog] {
        workout.exercises.sorted { $0.order < $1.order }
    }

    var currentExercise: ExerciseLog? {
        guard currentExerciseIndex < sortedExercises.count else { return nil }
        return sortedExercises[currentExerciseIndex]
    }

    var currentSet: ExerciseSet? {
        guard let ex = currentExercise,
              currentSetIndex < ex.sets.count else { return nil }
        return ex.sets[currentSetIndex]
    }

    var setProgress: String {
        "Set \(currentSetIndex + 1) of \(currentExercise?.sets.count ?? 0)"
    }

    var exerciseProgress: String {
        "\(currentExerciseIndex + 1) / \(sortedExercises.count)"
    }

    // MARK: - Hərəkətlər

    func completeCurrentSet() async {
        timer.stop()

        // Cari seti tamamlandı işarələ
        if let set = currentSet {
            set.isCompleted = true
            set.completedAt = Date()
            try? await repository.save(workout)
        }

        let exercises = sortedExercises
        let hasNextSet = currentSetIndex + 1 < (currentExercise?.sets.count ?? 0)
        let hasNextExercise = currentExerciseIndex + 1 < exercises.count

        if hasNextSet {
            currentSetIndex += 1
            startRest()
        } else if hasNextExercise {
            currentExerciseIndex += 1
            currentSetIndex = 0
            startRest()
        } else {
            // Bütün məşqlər bitdi
            workPhase = .done
            workout.isCompleted = true
            try? await repository.save(workout)
        }
    }

    func startRest() {
        workPhase = .resting
        // Hərəkətin öz fasiləsini istifadə et, olmasa default 60s
        let duration = TimeInterval(currentExercise?.restDuration ?? Int(defaultRestDuration))
        timer.startCountdown(from: duration)
    }

    // Dincəlmə taymeri bitdikdə (View tərəfindən çağırılır)
    func onRestFinished() {
        workPhase = .working
        timer.startCountup()
    }

    func skipRest() {
        workPhase = .working
        timer.stop()
        timer.startCountup()
    }
}
