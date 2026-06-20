import SwiftUI

struct ContentView: View {

    @Environment(AppRouter.self) private var router
    @Environment(DependencyContainer.self) private var dependencies

    var body: some View {
        NavigationStack(path: Bindable(router).path) {
            WorkoutListView(repository: dependencies.workoutRepository)
                .navigationDestination(for: AppRouter.Destination.self) { destination in
                    switch destination {
                    case .workoutDetail(let workout):
                        WorkoutDetailView(workout: workout, repository: dependencies.workoutRepository)
                    case .activeWorkout(let workout):
                        ActiveWorkoutView(workout: workout, repository: dependencies.workoutRepository)
                    case .exercisePicker(let workout):
                        ExercisePickerView(
                            workout: workout,
                            exerciseRepository: dependencies.exerciseRepository,
                            workoutRepository: dependencies.workoutRepository
                        )
                    }
                }
        }
    }
}
