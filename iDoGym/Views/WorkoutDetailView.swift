import SwiftUI

struct WorkoutDetailView: View {

    @State private var viewModel: WorkoutDetailViewModel
    @State private var activeWorkout: Workout?
    @State private var showingPicker = false

    let workout: Workout
    let workoutRepository: WorkoutRepositoryProtocol
    let exerciseRepository: ExerciseRepositoryProtocol

    init(workout: Workout,
         workoutRepository: WorkoutRepositoryProtocol,
         exerciseRepository: ExerciseRepositoryProtocol) {
        self.workout = workout
        self.workoutRepository = workoutRepository
        self.exerciseRepository = exerciseRepository
        _viewModel = State(wrappedValue: WorkoutDetailViewModel(workout: workout, repository: workoutRepository))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                if viewModel.sortedExercises.isEmpty {
                    emptyState
                } else {
                    ForEach(viewModel.sortedExercises) { log in
                        exerciseCard(log)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, 120)
        }
        .background(AppColors.background)
        .navigationTitle(workout.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingPicker = true
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.primary)
                }
            }
        }
        .overlay(alignment: .bottom) {
            if !viewModel.sortedExercises.isEmpty {
                startButton
            }
        }
        .sheet(isPresented: $showingPicker) {
            ExercisePickerView(
                workout: workout,
                exerciseRepository: exerciseRepository,
                workoutRepository: workoutRepository
            )
        }
        .fullScreenCover(item: $activeWorkout) { w in
            ActiveWorkoutView(workout: w, repository: workoutRepository)
        }
    }

    // MARK: - Boş vəziyyət

    private var emptyState: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 52))
                .foregroundStyle(AppColors.textTertiary)

            VStack(spacing: AppSpacing.sm) {
                Text("Hərəkət yoxdur")
                    .font(AppFonts.title2)
                    .foregroundStyle(AppColors.textPrimary)
                Text("'+' düyməsi ilə bu məşqə\nhərəkətlər əlavə et.")
                    .font(AppFonts.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                showingPicker = true
            } label: {
                Label("Hərəkət Əlavə Et", systemImage: "plus")
                    .font(AppFonts.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.vertical, AppSpacing.md)
                    .background(AppColors.primary)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }

    // MARK: - Hərəkət kartı

    private func exerciseCard(_ log: ExerciseLog) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(log.exercise?.name ?? "Hərəkət")
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    Text(log.exercise?.muscleGroup.displayName ?? "")
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.textSecondary)
                }

                Spacer()

                // Set sayını artır/azalt
                HStack(spacing: AppSpacing.sm) {
                    Button {
                        guard log.sets.count > 1, let last = log.sets.last else { return }
                        Task { await viewModel.deleteSet(last, from: log) }
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(AppColors.primary)
                            .frame(width: 28, height: 28)
                            .background(AppColors.primary.opacity(0.1))
                            .clipShape(Circle())
                    }

                    Text("\(log.sets.count) set")
                        .font(AppFonts.captionBold)
                        .foregroundStyle(AppColors.textPrimary)
                        .frame(minWidth: 48)
                        .multilineTextAlignment(.center)

                    Button {
                        Task { await viewModel.addSet(to: log) }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(AppColors.primary)
                            .frame(width: 28, height: 28)
                            .background(AppColors.primary.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }

            // Set detalları + fasilə
            HStack(spacing: AppSpacing.xs) {
                if let firstSet = log.sets.first {
                    let w = firstSet.weight > 0 ? " · \(String(format: "%.0f", firstSet.weight))kg" : ""
                    Text("\(log.sets.count) × \(firstSet.reps) reps\(w)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(AppColors.textSecondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "#F4F3F8"))
                        .clipShape(Capsule())
                }

                // Fasilə
                HStack(spacing: 3) {
                    Image(systemName: "timer")
                        .font(.system(size: 10))
                    Text(restLabel(log.restDuration))
                        .font(.system(size: 11, weight: .medium))
                }
                .foregroundStyle(AppColors.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(AppColors.primary.opacity(0.08))
                .clipShape(Capsule())
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                Task { await viewModel.removeExercise(log) }
            } label: {
                Label("Sil", systemImage: "trash")
            }
        }
    }

    private func restLabel(_ seconds: Int) -> String {
        seconds < 60 ? "\(seconds)s" : "\(seconds / 60)m\(seconds % 60 == 0 ? "" : " \(seconds % 60)s")"
    }

    // MARK: - Start düyməsi

    private var startButton: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [AppColors.background.opacity(0), AppColors.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 24)

            Button {
                activeWorkout = workout
            } label: {
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 16))
                    Text("Məşqə Başla")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(AppColors.primary)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                .shadow(color: AppColors.primary.opacity(0.3), radius: 8, y: 4)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, AppSpacing.lg)
            .background(AppColors.background)
        }
    }
}

#Preview {
    NavigationStack {
        WorkoutDetailView(
            workout: Workout(name: "Push Day"),
            workoutRepository: PreviewDetailWorkoutRepo(),
            exerciseRepository: PreviewDetailExerciseRepo()
        )
    }
}

private class PreviewDetailWorkoutRepo: WorkoutRepositoryProtocol {
    func fetchAll() async throws -> [Workout] { [] }
    func save(_ workout: Workout) async throws {}
    func delete(_ workout: Workout) async throws {}
}

private class PreviewDetailExerciseRepo: ExerciseRepositoryProtocol {
    func fetchAll() async throws -> [Exercise] { [] }
    func save(_ exercise: Exercise) async throws {}
    func seedDefaultsIfNeeded() async throws {}
}
