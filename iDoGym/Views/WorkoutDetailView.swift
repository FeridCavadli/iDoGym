import SwiftUI

struct WorkoutDetailView: View {

    @Environment(AppRouter.self) private var router
    @State private var viewModel: WorkoutDetailViewModel

    init(workout: Workout, repository: WorkoutRepositoryProtocol) {
        _viewModel = State(initialValue: WorkoutDetailViewModel(workout: workout, repository: repository))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            AppColors.background.ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: AppSpacing.md) {
                    ForEach(viewModel.sortedExercises) { log in
                        ExerciseLogSection(log: log, viewModel: viewModel)
                    }
                }
                .padding(AppSpacing.md)
                .padding(.bottom, 90)  // alt düymə üçün boşluq
            }

            // Alt — Məşqə Başla düyməsi
            Button {
                router.navigate(to: .activeWorkout(viewModel.workout))
            } label: {
                Text("Start Workout")
                    .font(AppFonts.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(AppSpacing.md)
                    .background(AppColors.primary)
                    .cornerRadius(AppRadius.pill)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, AppSpacing.lg)
        }
        .navigationTitle(viewModel.workout.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(AppColors.background, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Bir məşqin bölməsi (Exercise + onun set-ləri)
private struct ExerciseLogSection: View {

    let log: ExerciseLog
    let viewModel: WorkoutDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {

            // Məşq adı və əzələ qrupu
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(log.exercise?.name ?? "Exercise")
                    .font(AppFonts.title2)
                    .foregroundStyle(AppColors.textPrimary)

                Text(log.exercise?.muscleGroup.displayName ?? "")
                    .font(AppFonts.subheadline)
                    .foregroundStyle(AppColors.secondary)
            }

            // Set sıraları
            VStack(spacing: AppSpacing.xs) {
                ForEach(Array(log.sets.enumerated()), id: \.element.id) { index, set in
                    SetRowView(
                        set: set,
                        index: index,
                        onToggle: { await viewModel.toggleCompletion(set) },
                        onDelete: { await viewModel.deleteSet(set, from: log) }
                    )
                }
            }

            // Set əlavə et düyməsi
            Button {
                Task { await viewModel.addSet(to: log) }
            } label: {
                Label("Add Set", systemImage: "plus")
                    .font(AppFonts.subheadline)
                    .foregroundStyle(AppColors.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.sm)
                    .background(AppColors.surface)
                    .cornerRadius(AppRadius.md)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surfaceSecondary)
        .cornerRadius(AppRadius.lg)
    }
}

// MARK: - Bir set sırası
private struct SetRowView: View {

    let set: ExerciseSet
    let index: Int
    let onToggle: () async -> Void
    let onDelete: () async -> Void

    var body: some View {
        HStack(spacing: AppSpacing.md) {

            // Set nömrəsi: "1 set"
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text("\(index + 1)")
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.textSecondary)
                Text("set")
                    .font(AppFonts.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .frame(width: 48, alignment: .leading)

            Spacer()

            // Çəki: "60 kg"
            HStack(alignment: .lastTextBaseline, spacing: 3) {
                Text("\(Int(set.weight))")
                    .font(AppFonts.setNumber)
                    .foregroundStyle(AppColors.textPrimary)
                Text("kg")
                    .font(AppFonts.setLabel)
                    .foregroundStyle(AppColors.textSecondary)
            }

            // Təkrar: "10 reps"
            HStack(alignment: .lastTextBaseline, spacing: 3) {
                Text("\(set.reps)")
                    .font(AppFonts.setNumber)
                    .foregroundStyle(AppColors.textPrimary)
                Text("reps")
                    .font(AppFonts.setLabel)
                    .foregroundStyle(AppColors.textSecondary)
            }

            // Tamamlandı işarəsi
            Button {
                Task { await onToggle() }
            } label: {
                Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(
                        set.isCompleted ? AppColors.secondary : AppColors.textTertiary
                    )
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm + 2)
        .background(AppColors.surface)
        .cornerRadius(AppRadius.md)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                Task { await onDelete() }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
