import SwiftUI

struct WorkoutListView: View {

    @Environment(AppRouter.self) private var router
    @State private var viewModel: WorkoutListViewModel

    // Yeni workout əlavə etmək üçün alert vəziyyəti
    @State private var showingAddWorkout = false
    @State private var newWorkoutName = ""

    init(repository: WorkoutRepositoryProtocol) {
        // _viewModel — @State-in daxili dəyərini init-də set etmək üçün
        _viewModel = State(initialValue: WorkoutListViewModel(repository: repository))
    }

    var body: some View {
        List {
            ForEach(viewModel.workouts) { workout in
                Button(workout.name) {
                    router.navigate(to: .workoutDetail(workout))
                }
                .foregroundStyle(.primary)
            }
            .onDelete { indexSet in
                Task {
                    for index in indexSet {
                        await viewModel.deleteWorkout(viewModel.workouts[index])
                    }
                }
            }
        }
        .navigationTitle("My Workouts")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddWorkout = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .alert("New Workout", isPresented: $showingAddWorkout) {
            TextField("Chest Day, Push A...", text: $newWorkoutName)
            Button("Create") {
                Task {
                    await viewModel.addWorkout(name: newWorkoutName)
                    newWorkoutName = ""
                }
            }
            Button("Cancel", role: .cancel) {
                newWorkoutName = ""
            }
        }
        .task {
            await viewModel.loadWorkouts()
        }
    }
}
