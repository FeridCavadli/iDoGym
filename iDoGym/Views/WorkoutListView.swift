import SwiftUI

struct WorkoutListView: View {

    @Environment(AppRouter.self) private var router
    @State private var viewModel: WorkoutListViewModel
    @State private var showingAddWorkout = false
    @State private var newWorkoutName = ""

    init(repository: WorkoutRepositoryProtocol) {
        _viewModel = State(initialValue: WorkoutListViewModel(repository: repository))
    }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            if viewModel.workouts.isEmpty {
                emptyState
            } else {
                workoutList
            }
        }
        .navigationTitle("My Workouts")
        .toolbarBackground(AppColors.background, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddWorkout = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColors.primary)
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

    // MARK: - Boş vəziyyət

    private var emptyState: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 64))
                .foregroundStyle(AppColors.textTertiary)

            Text("No Workouts Yet")
                .font(AppFonts.title2)
                .foregroundStyle(AppColors.textPrimary)

            Text("Tap + to create your first workout")
                .font(AppFonts.subheadline)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    // MARK: - Workout siyahısı

    private var workoutList: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(viewModel.workouts) { workout in
                    WorkoutCard(workout: workout) {
                        router.navigate(to: .workoutDetail(workout))
                    } onDelete: {
                        Task { await viewModel.deleteWorkout(workout) }
                    }
                }
            }
            .padding(AppSpacing.md)
        }
    }
}

// MARK: - Workout kartı

private struct WorkoutCard: View {
    let workout: Workout
    let onTap: () -> Void
    let onDelete: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(workout.name)
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.textPrimary)

                    Text(workout.date.formatted(date: .abbreviated, time: .omitted))
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.textSecondary)

                    if workout.totalSets > 0 {
                        Text("\(workout.exercises.count) exercises · \(workout.totalSets) sets")
                            .font(AppFonts.caption)
                            .foregroundStyle(AppColors.textTertiary)
                    }
                }

                Spacer()

                // Tamamlanma göstəricisi
                if workout.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(AppColors.success)
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(AppColors.textTertiary)
                }
            }
            .padding(AppSpacing.md)
            .background(AppColors.surface)
            .cornerRadius(AppRadius.lg)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
