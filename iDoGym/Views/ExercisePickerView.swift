import SwiftUI

struct ExercisePickerView: View {

    @Environment(AppRouter.self) private var router
    @State private var viewModel: ExercisePickerViewModel

    let workout: Workout

    init(workout: Workout, exerciseRepository: ExerciseRepositoryProtocol, workoutRepository: WorkoutRepositoryProtocol) {
        self.workout = workout
        _viewModel = State(initialValue: ExercisePickerViewModel(
            exerciseRepository: exerciseRepository,
            workoutRepository: workoutRepository
        ))
    }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Əzələ qrupu filterləri
                muscleGroupFilter

                // Məşqlər siyahısı
                exerciseList
            }
        }
        .navigationTitle("Add Exercise")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(AppColors.background, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task {
            await viewModel.load()
        }
    }

    // MARK: - Kateqoriya filterləri (üfüqi sürüşən)

    private var muscleGroupFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                // "All" düyməsi
                FilterChip(
                    title: "All",
                    isSelected: viewModel.selectedMuscleGroup == nil
                ) {
                    viewModel.selectedMuscleGroup = nil
                }

                ForEach(MuscleGroup.allCases, id: \.self) { group in
                    FilterChip(
                        title: group.displayName,
                        isSelected: viewModel.selectedMuscleGroup == group
                    ) {
                        viewModel.selectedMuscleGroup =
                            viewModel.selectedMuscleGroup == group ? nil : group
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
        }
    }

    // MARK: - Məşqlər siyahısı

    private var exerciseList: some View {
        List(viewModel.filteredExercises) { exercise in
            ExerciseRow(exercise: exercise) {
                Task {
                    await viewModel.addExercise(exercise, to: workout)
                    router.goBack()
                }
            }
            .listRowBackground(AppColors.surface)
            .listRowSeparatorTint(AppColors.surfaceSecondary)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

// MARK: - Filter Chip (kateqoriya düyməsi)

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.subheadline)
                .foregroundStyle(isSelected ? .black : AppColors.textSecondary)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(isSelected ? AppColors.primary : AppColors.surface)
                .cornerRadius(AppRadius.pill)
        }
    }
}

// MARK: - Məşq sırası

private struct ExerciseRow: View {
    let exercise: Exercise
    let onAdd: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(exercise.name)
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.textPrimary)

                Text(exercise.muscleGroup.displayName)
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()

            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(AppColors.primary)
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }
}
