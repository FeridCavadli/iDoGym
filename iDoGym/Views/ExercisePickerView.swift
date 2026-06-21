import SwiftUI

struct ExercisePickerView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ExercisePickerViewModel

    let workout: Workout

    init(workout: Workout,
         exerciseRepository: ExerciseRepositoryProtocol,
         workoutRepository: WorkoutRepositoryProtocol) {
        self.workout = workout
        _viewModel = State(wrappedValue: ExercisePickerViewModel(
            exerciseRepository: exerciseRepository,
            workoutRepository: workoutRepository
        ))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                muscleGroupFilter

                Divider()

                if viewModel.filteredExercises.isEmpty {
                    emptyState
                } else {
                    exerciseList
                }
            }
            .background(AppColors.background)
            .navigationTitle("Hərəkət Seç")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Bağla") { dismiss() }
                        .foregroundStyle(AppColors.primary)
                }
            }
            .task { await viewModel.load() }
        }
    }

    // MARK: - Əzələ qrupu filterləri

    private var muscleGroupFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                filterChip(title: "Hamısı", isActive: viewModel.selectedMuscleGroup == nil) {
                    viewModel.selectedMuscleGroup = nil
                }
                ForEach(MuscleGroup.allCases, id: \.self) { group in
                    filterChip(title: group.displayName, isActive: viewModel.selectedMuscleGroup == group) {
                        viewModel.selectedMuscleGroup = group
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
        .padding(.vertical, AppSpacing.sm)
    }

    private func filterChip(title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Text(title)
            .font(AppFonts.captionBold)
            .tracking(0.6)
            .foregroundStyle(isActive ? AppColors.primary : AppColors.textSecondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isActive ? AppColors.primary.opacity(0.1) : AppColors.surface)
                    .overlay(Capsule().stroke(isActive ? AppColors.primary : Color(hex: "#C1C6D7"), lineWidth: 1))
            )
            .onTapGesture { action() }
    }

    // MARK: - Hərəkət siyahısı

    private var exerciseList: some View {
        ScrollView {
            VStack(spacing: AppSpacing.sm) {
                ForEach(viewModel.filteredExercises) { exercise in
                    exerciseRow(exercise)
                }
            }
            .padding(AppSpacing.md)
        }
    }

    private func exerciseRow(_ exercise: Exercise) -> some View {
        // Bu məşq artıq əlavə edilibsə işarələ
        let alreadyAdded = workout.exercises.contains { $0.exercise?.id == exercise.id }

        return Button {
            guard !alreadyAdded else { return }
            Task { await viewModel.addExercise(exercise, to: workout) }
        } label: {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppRadius.sm)
                        .fill(AppColors.primary.opacity(0.1))
                        .frame(width: 44, height: 44)
                    Image(systemName: exercise.muscleGroup.systemIcon)
                        .font(.system(size: 18))
                        .foregroundStyle(AppColors.primary)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(exercise.name)
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    Text(exercise.muscleGroup.displayName)
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }

                Spacer()

                Image(systemName: alreadyAdded ? "checkmark.circle.fill" : "plus.circle")
                    .font(.system(size: 22))
                    .foregroundStyle(alreadyAdded ? AppColors.success : AppColors.primary)
            }
            .padding(AppSpacing.md)
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .cardShadow()
            .opacity(alreadyAdded ? 0.6 : 1)
        }
        .disabled(alreadyAdded)
    }

    // MARK: - Boş vəziyyət

    private var emptyState: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundStyle(AppColors.textTertiary)
            Text("Hərəkət tapılmadı")
                .font(AppFonts.body)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
