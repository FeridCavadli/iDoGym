import SwiftUI

struct WorkoutTabView: View {

    @Environment(AppRouter.self) private var router
    @State private var viewModel: WorkoutListViewModel
    @State private var showingCreate = false
    @State private var newWorkoutName = ""

    let exerciseRepository: ExerciseRepositoryProtocol

    init(workoutRepository: WorkoutRepositoryProtocol,
         exerciseRepository: ExerciseRepositoryProtocol) {
        _viewModel = State(wrappedValue: WorkoutListViewModel(repository: workoutRepository))
        self.exerciseRepository = exerciseRepository
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.workouts.isEmpty {
                    emptyState
                } else {
                    workoutList
                }
            }
            .background(AppColors.background)
            .navigationTitle("Workout")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCreate = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.primary)
                    }
                }
            }
            .task { await viewModel.loadWorkouts() }
            // Programs tab-dan "Create Your Own" basılanda bu açılır
            .onChange(of: router.shouldShowCreateWorkout) { _, should in
                if should {
                    showingCreate = true
                    router.shouldShowCreateWorkout = false
                }
            }
            .alert("Yeni Məşq", isPresented: $showingCreate) {
                TextField("Məşq adı (məs. Chest Day)", text: $newWorkoutName)
                Button("Ləğv et", role: .cancel) { newWorkoutName = "" }
                Button("Yarat") {
                    let name = newWorkoutName.trimmingCharacters(in: .whitespaces)
                    guard !name.isEmpty else { return }
                    Task {
                        await viewModel.addWorkout(name: name)
                        newWorkoutName = ""
                    }
                }
            }
        }
    }

    // MARK: - Boş vəziyyət

    private var emptyState: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "dumbbell")
                .font(.system(size: 56))
                .foregroundStyle(AppColors.textTertiary)

            VStack(spacing: AppSpacing.sm) {
                Text("Məşq yoxdur")
                    .font(AppFonts.title2)
                    .foregroundStyle(AppColors.textPrimary)
                Text("İlk məşqini yarat və\nantrenmanına başla.")
                    .font(AppFonts.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                showingCreate = true
            } label: {
                Text("Məşq Yarat")
                    .font(AppFonts.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: 200)
                    .padding(.vertical, AppSpacing.md)
                    .background(AppColors.primary)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Məşq siyahısı
    // List — swipeActions-ın işləməsi üçün vacibdir (ScrollView-da işləmir)

    private var workoutList: some View {
        List {
            ForEach(viewModel.workouts) { workout in
                NavigationLink {
                    WorkoutDetailView(
                        workout: workout,
                        workoutRepository: viewModel.repository,
                        exerciseRepository: exerciseRepository
                    )
                } label: {
                    workoutCard(workout)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        Task { await viewModel.deleteWorkout(workout) }
                    } label: {
                        Label("Sil", systemImage: "trash")
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(
                    top: AppSpacing.sm / 2,
                    leading: AppSpacing.md,
                    bottom: AppSpacing.sm / 2,
                    trailing: AppSpacing.md
                ))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func workoutCard(_ workout: Workout) -> some View {
        HStack(spacing: AppSpacing.md) {
            RoundedRectangle(cornerRadius: 3)
                .fill(workout.isCompleted ? AppColors.success : AppColors.primary)
                .frame(width: 4, height: 56)

            VStack(alignment: .leading, spacing: 4) {
                Text(workout.name)
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.textPrimary)

                HStack(spacing: AppSpacing.sm) {
                    Label("\(workout.exercises.count) hərəkət", systemImage: "list.bullet")
                    Label(workout.date.formatted(date: .abbreviated, time: .omitted),
                          systemImage: "calendar")
                }
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()

            Image(systemName: workout.isCompleted ? "checkmark.circle.fill" : "chevron.right")
                .font(.system(size: workout.isCompleted ? 22 : 14))
                .foregroundStyle(workout.isCompleted ? AppColors.success : AppColors.textTertiary)
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
    }
}

#Preview {
    WorkoutTabView(
        workoutRepository: PreviewWorkoutRepository(),
        exerciseRepository: PreviewExerciseRepository()
    )
    .environment(AppRouter())
}

private class PreviewWorkoutRepository: WorkoutRepositoryProtocol {
    func fetchAll() async throws -> [Workout] { [] }
    func save(_ workout: Workout) async throws {}
    func delete(_ workout: Workout) async throws {}
}

private class PreviewExerciseRepository: ExerciseRepositoryProtocol {
    func fetchAll() async throws -> [Exercise] { [] }
    func save(_ exercise: Exercise) async throws {}
    func seedDefaultsIfNeeded() async throws {}
}
