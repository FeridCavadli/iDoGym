import SwiftUI

struct ActiveWorkoutView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ActiveWorkoutViewModel

    enum TimerPhase {
        case work, rest
        var label: String { self == .work ? "WORK" : "REST" }
        var color: Color { self == .work ? AppColors.primary : AppColors.success }
    }

    init(workout: Workout, repository: WorkoutRepositoryProtocol) {
        _viewModel = State(wrappedValue: ActiveWorkoutViewModel(workout: workout, repository: repository))
    }

    // ViewModel-dən gələn real məlumatlar
    private var exerciseName: String {
        viewModel.currentExercise?.exercise?.name ?? viewModel.workout.name
    }

    private var setProgress: String { viewModel.setProgress }

    private var targetReps: String {
        if let reps = viewModel.currentSet?.reps { return "\(reps)" }
        return "--"
    }

    private var targetWeight: String {
        if let w = viewModel.currentSet?.weight, w > 0 { return String(format: "%.0f", w) }
        return "--"
    }

    private var nextUpText: String {
        // Növbəti məşqi göstər
        let exercises = viewModel.workout.exercises.sorted { $0.order < $1.order }
        let nextIdx = viewModel.currentExerciseIndex + 1
        if nextIdx < exercises.count, let name = exercises[nextIdx].exercise?.name {
            return name
        }
        return "Son set"
    }

    private var timerPhase: TimerPhase {
        viewModel.workPhase == .resting ? .rest : .work
    }

    private var progress: CGFloat {
        if timerPhase == .rest {
            let total = viewModel.timer.totalDuration
            guard total > 0 else { return 1 }
            return CGFloat(viewModel.timer.remaining / total)
        }
        return 1.0
    }

    private var timeString: String {
        // Dincəlmədə: TimerService-dən remaining, işdə: elapsed
        let t = Int(timerPhase == .rest ? viewModel.timer.remaining : viewModel.timer.elapsed)
        return String(format: "%02d:%02d", t / 60, t % 60)
    }

    var body: some View {
        ZStack {
            // Fon
            Color(hex: "#FAF9FE").ignoresSafeArea()

            // Arxa ambient işıq effekti
            Circle()
                .fill(AppColors.primary.opacity(0.1))
                .frame(width: 384, height: 384)
                .blur(radius: 32)

            VStack(spacing: 0) {
                // Üst boşluq (custom header üçün)
                Spacer().frame(height: 56)

                Spacer()

                // Məşq adı + set sayı
                VStack(spacing: 6) {
                    Text(exerciseName)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                        .multilineTextAlignment(.center)

                    HStack(spacing: AppSpacing.sm) {
                        Circle()
                            .fill(AppColors.primary)
                            .frame(width: 8, height: 8)
                        Text(setProgress)
                            .font(AppFonts.captionBold)
                            .tracking(0.6)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#E3E2E7"))
                    .clipShape(Capsule())
                }
                .padding(.bottom, AppSpacing.lg)

                // Taymer dairəsi
                timerCircle
                    .padding(.bottom, AppSpacing.lg)

                // Set detalları
                setDetailsCard

                Spacer()

                // Alt kontrol footer üçün boşluq
                Spacer().frame(height: 160)
            }

            // Custom üst header
            VStack {
                topBar
                Spacer()
                bottomControls
            }
            .ignoresSafeArea(edges: .bottom)
        }
        // Dincəlmə taymeri bitdikdə
        .onChange(of: viewModel.timer.phase) { _, phase in
            if phase == .finished {
                viewModel.onRestFinished()
            }
        }
        // Məşq bitdikdə ekranı bağla
        .onChange(of: viewModel.workPhase) { _, phase in
            if phase == .done { dismiss() }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button {
                viewModel.timer.stop()
                dismiss()
            } label: {
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppColors.primary)
                    Text("iDoGym")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(AppColors.primary)
                }
            }

            Spacer()

            HStack(spacing: AppSpacing.md) {
                statLabel(title: "ELAPSED", value: TimerService.format(viewModel.timer.elapsed))
                statLabel(title: "SETS", value: "\(viewModel.workout.completedSets)")
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .frame(height: 56)
        .background(.ultraThinMaterial)
    }

    private func statLabel(title: String, value: String) -> some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text(title)
                .font(AppFonts.captionBold)
                .tracking(0.6)
                .foregroundStyle(AppColors.textPrimary.opacity(0.7))
            Text(value)
                .font(AppFonts.captionBold)
                .tracking(0.6)
                .foregroundStyle(AppColors.textPrimary)
        }
    }

    // MARK: - Timer Circle

    private var timerCircle: some View {
        ZStack {
            // Boz arxa halqa
            Circle()
                .stroke(Color(hex: "#E3E2E7"), lineWidth: 12)
                .frame(width: 260, height: 260)

            // Mavi irəliləmə halqası
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    timerPhase.color,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: 260, height: 260)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)

            // Ağ daxili dairə
            Circle()
                .fill(Color.white)
                .frame(width: 240, height: 240)
                .shadow(color: .black.opacity(0.05), radius: 6, y: 4)

            // Taymer mətni
            VStack(spacing: 4) {
                Text(timeString)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundStyle(AppColors.textPrimary)
                    .tracking(-2.4)

                Text(timerPhase.label)
                    .font(AppFonts.captionBold)
                    .tracking(0.6)
                    .foregroundStyle(timerPhase.color)
            }
        }
    }

    // MARK: - Set Details

    private var setDetailsCard: some View {
        HStack(spacing: AppSpacing.xl) {
            setDetailItem(label: "Target Reps", value: targetReps)

            Rectangle()
                .fill(Color(hex: "#C1C6D7"))
                .frame(width: 1)
                .frame(height: 40)

            setDetailItem(label: "Weight (kg)", value: targetWeight)
        }
        .padding(AppSpacing.md)
        .background(Color(hex: "#F4F3F8"))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
        .padding(.horizontal, AppSpacing.md)
    }

    private func setDetailItem(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(AppFonts.captionBold)
                .tracking(0.6)
                .foregroundStyle(AppColors.textSecondary)
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppColors.textPrimary)
        }
    }

    // MARK: - Bottom Controls

    private var bottomControls: some View {
        VStack(spacing: 0) {
            // Next Up
            HStack {
                Text("Next Up:")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(AppColors.textSecondary)
                Spacer()
                Text(nextUpText)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.md)
            .background(Color(hex: "#E9E7ED"))

            // 3 düymə
            HStack(spacing: AppSpacing.md) {
                // Pause / Resume
                Button {
                    if viewModel.timer.phase == .running {
                        viewModel.timer.pause()
                    } else {
                        viewModel.timer.resume()
                    }
                } label: {
                    Image(systemName: viewModel.timer.phase == .running ? "pause.fill" : "play.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(AppColors.textPrimary)
                        .frame(width: 64, height: 64)
                        .background(Color(hex: "#E3E2E7"))
                        .clipShape(Circle())
                }

                // Log Set
                Button {
                    Task { await viewModel.completeCurrentSet() }
                } label: {
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                        Text("Log Set")
                            .font(.system(size: 16))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColors.primary)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
                }

                // Skip rest
                Button {
                    viewModel.skipRest()
                } label: {
                    Image(systemName: "forward.end.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(AppColors.textPrimary)
                        .frame(width: 64, height: 64)
                        .background(Color(hex: "#E3E2E7"))
                        .clipShape(Circle())
                }
            }
            .padding(AppSpacing.md)
        }
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Divider()
        }
    }
}

#Preview {
    let workout = Workout(name: "Push Day")
    return ActiveWorkoutView(
        workout: workout,
        repository: PreviewWorkoutRepo()
    )
}

private class PreviewWorkoutRepo: WorkoutRepositoryProtocol {
    func fetchAll() async throws -> [Workout] { [] }
    func save(_ workout: Workout) async throws {}
    func delete(_ workout: Workout) async throws {}
}
