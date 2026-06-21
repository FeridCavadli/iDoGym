import SwiftUI

struct ExercisePickerView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ExercisePickerViewModel
    @State private var configuringExercise: Exercise?

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
            // Hərəkət seçiləndə konfiqurasiya sheet-i aç
            .sheet(item: $configuringExercise) { exercise in
                ExerciseConfigSheet(exercise: exercise) { sets, reps, weight, rest in
                    Task {
                        await viewModel.addExercise(
                            exercise, to: workout,
                            sets: sets, reps: reps,
                            weight: weight, restDuration: rest
                        )
                        configuringExercise = nil
                    }
                }
            }
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
        let alreadyAdded = workout.exercises.contains { $0.exercise?.id == exercise.id }

        return Button {
            guard !alreadyAdded else { return }
            configuringExercise = exercise
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

// MARK: - Konfigurasiya Sheet-i

private struct ExerciseConfigSheet: View {

    let exercise: Exercise
    // sets, reps, weight, restDuration
    let onConfirm: (Int, Int, Double, Int) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var sets = 3
    @State private var reps = 10
    @State private var weight: Double = 0
    @State private var selectedRest = 60

    // Ən çox istifadə olunan fasilə variantları
    private let restOptions = [30, 45, 60, 90, 120, 180]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {

                    // Hərəkət başlığı
                    HStack(spacing: AppSpacing.md) {
                        ZStack {
                            RoundedRectangle(cornerRadius: AppRadius.sm)
                                .fill(AppColors.primary.opacity(0.1))
                                .frame(width: 52, height: 52)
                            Image(systemName: exercise.muscleGroup.systemIcon)
                                .font(.system(size: 22))
                                .foregroundStyle(AppColors.primary)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(exercise.name)
                                .font(AppFonts.title2)
                                .foregroundStyle(AppColors.textPrimary)
                            Text(exercise.muscleGroup.displayName)
                                .font(AppFonts.caption)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(AppSpacing.md)
                    .background(AppColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                    .cardShadow()

                    // Set sayı + Reps yan-yana
                    HStack(spacing: AppSpacing.md) {
                        counterCard(
                            icon: "number.circle.fill",
                            title: "SET SAYI",
                            value: $sets,
                            range: 1...10,
                            unit: "set"
                        )
                        counterCard(
                            icon: "repeat",
                            title: "TEKRARİ",
                            value: $reps,
                            range: 1...50,
                            unit: "reps"
                        )
                    }

                    // Çəki
                    weightCard

                    // Fasilə seçimi
                    restCard
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, 100)
            }
            .background(AppColors.background)
            .navigationTitle("Konfiqur Et")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Ləğv et") { dismiss() }
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .safeAreaInset(edge: .bottom) {
                confirmButton
            }
        }
    }

    // MARK: - Counter Kartı (set / reps)

    private func counterCard(icon: String, title: String, value: Binding<Int>, range: ClosedRange<Int>, unit: String) -> some View {
        VStack(spacing: AppSpacing.sm) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(AppColors.primary)
                Spacer()
                Text(title)
                    .font(AppFonts.captionBold)
                    .tracking(0.6)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Text("\(value.wrappedValue)")
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
                .tracking(-0.9)

            Text(unit)
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)

            // +/- düymələri
            HStack(spacing: AppSpacing.md) {
                Button {
                    if value.wrappedValue > range.lowerBound { value.wrappedValue -= 1 }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(AppColors.primary)
                        .frame(width: 36, height: 36)
                        .background(AppColors.primary.opacity(0.1))
                        .clipShape(Circle())
                }

                Button {
                    if value.wrappedValue < range.upperBound { value.wrappedValue += 1 }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(AppColors.primary)
                        .frame(width: 36, height: 36)
                        .background(AppColors.primary.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
    }

    // MARK: - Çəki Kartı

    private var weightCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Image(systemName: "scalemass.fill")
                    .foregroundStyle(AppColors.primary)
                Spacer()
                Text("ÇƏKİ")
                    .font(AppFonts.captionBold)
                    .tracking(0.6)
                    .foregroundStyle(AppColors.textSecondary)
            }

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(weight == 0 ? "Bədən" : String(format: "%.1f", weight))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                if weight > 0 {
                    Text("kg")
                        .font(AppFonts.subheadline)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }

            HStack(spacing: AppSpacing.sm) {
                // Sıfırla (bədən çəkisi)
                Button {
                    weight = 0
                } label: {
                    Text("Bədən")
                        .font(AppFonts.captionBold)
                        .foregroundStyle(weight == 0 ? .white : AppColors.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(weight == 0 ? AppColors.primary : AppColors.primary.opacity(0.1))
                        .clipShape(Capsule())
                }

                Spacer()

                // -2.5 | -1 | +1 | +2.5
                ForEach([-2.5, -1.0, 1.0, 2.5], id: \.self) { delta in
                    Button {
                        weight = max(0, weight + delta)
                    } label: {
                        Text(delta > 0 ? "+\(delta.formatted)" : delta.formatted)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(AppColors.primary)
                            .frame(width: 44, height: 32)
                            .background(AppColors.primary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
    }

    // MARK: - Fasilə Kartı

    private var restCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Image(systemName: "timer")
                    .foregroundStyle(AppColors.primary)
                Spacer()
                Text("SETLƏR ARASI FASİLƏ")
                    .font(AppFonts.captionBold)
                    .tracking(0.6)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Text(restLabel(selectedRest))
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)

            // Fasilə variantları
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.sm) {
                ForEach(restOptions, id: \.self) { option in
                    Button {
                        selectedRest = option
                    } label: {
                        Text(restLabel(option))
                            .font(AppFonts.captionBold)
                            .foregroundStyle(selectedRest == option ? .white : AppColors.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppSpacing.sm)
                            .background(selectedRest == option ? AppColors.primary : AppColors.primary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
    }

    private func restLabel(_ seconds: Int) -> String {
        seconds < 60 ? "\(seconds)s" : "\(seconds / 60)m\(seconds % 60 == 0 ? "" : " \(seconds % 60)s")"
    }

    // MARK: - Təsdiq düyməsi

    private var confirmButton: some View {
        Button {
            onConfirm(sets, reps, weight, selectedRest)
        } label: {
            Text("Hərəkəti Əlavə Et")
                .font(.system(size: 18, weight: .semibold))
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

// Double formatını qısaltmaq üçün
private extension Double {
    var formatted: String {
        self == self.rounded() ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}
