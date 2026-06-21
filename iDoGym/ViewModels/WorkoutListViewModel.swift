import Foundation

@Observable
final class WorkoutListViewModel {

    // View bu property-ləri izləyir — dəyişəndə UI avtomatik yenilənir
    var workouts: [Workout] = []
    var isLoading = false
    var errorMessage: String?

    // Protokol tipi — SwiftData-dan xəbərsizdir
    let repository: WorkoutRepositoryProtocol

    init(repository: WorkoutRepositoryProtocol) {
        self.repository = repository
    }

    func loadWorkouts() async {
        isLoading = true
        defer { isLoading = false }   // bu blok funksiya bitəndə mütləq işləyir

        do {
            workouts = try await repository.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addWorkout(name: String) async {
        let workout = Workout(name: name)
        do {
            try await repository.save(workout)
            await loadWorkouts()      // siyahını yenilə
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteWorkout(_ workout: Workout) async {
        do {
            try await repository.delete(workout)
            await loadWorkouts()      // siyahını yenilə
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
