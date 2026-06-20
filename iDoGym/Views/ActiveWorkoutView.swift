import SwiftUI

struct ActiveWorkoutView: View {

    @Environment(AppRouter.self) private var router
    @State private var viewModel: ActiveWorkoutViewModel

    init(workout: Workout, repository: WorkoutRepositoryProtocol) {
        _viewModel = State(initialValue: ActiveWorkoutViewModel(workout: workout, repository: repository))
    }

    // Fazaya görə rəng — WORK: qırmızı, REST: teal
    var accentColor: Color {
        switch viewModel.workPhase {
        case .working: return AppColors.timerActive
        case .resting: return AppColors.timerRest
        case .done:    return AppColors.success
        }
    }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: AppSpacing.xl) {
                headerBar
                exerciseInfoSection
                Spacer()
                timerSection
                Spacer()
                actionSection
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.lg)
        }
        // Naviqasiya barını gizlət — tam ekran taymer təcrübəsi
        .toolbar(.hidden, for: .navigationBar)
        // Dincəlmə taymeri bitdikdə növbəti seti başlat
        .onChange(of: viewModel.timer.phase) { _, newPhase in
            if newPhase == .finished && viewModel.workPhase == .resting {
                viewModel.onRestFinished()
            }
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack {
            // Geri düyməsi
            Button {
                viewModel.timer.stop()
                router.goBack()
            } label: {
                Image(systemName: "chevron.left")
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.textPrimary)
            }

            Spacer()

            // Faza göstəricisi: WORK / REST
            Text(viewModel.workPhase == .resting ? "REST" : "WORK")
                .font(AppFonts.caption)
                .fontWeight(.semibold)
                .foregroundStyle(accentColor)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
                .background(accentColor.opacity(0.15))
                .cornerRadius(AppRadius.pill)

            Spacer()

            // Bitir düyməsi
            Button("Finish") {
                viewModel.timer.stop()
                router.goToRoot()
            }
            .font(AppFonts.subheadline)
            .foregroundStyle(AppColors.textSecondary)
        }
    }

    // MARK: - Məşq məlumatı

    private var exerciseInfoSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            // "Set 1 of 3 · 2/4 Exercise"
            HStack(spacing: AppSpacing.sm) {
                Text(viewModel.setProgress)
                Text("·")
                Text("Exercise \(viewModel.exerciseProgress)")
            }
            .font(AppFonts.subheadline)
            .foregroundStyle(AppColors.textSecondary)

            // Məşq adı
            Text(viewModel.currentExercise?.exercise?.name ?? "Exercise")
                .font(AppFonts.title)
                .foregroundStyle(AppColors.textPrimary)

            // Çəki və təkrar
            if let set = viewModel.currentSet {
                HStack(spacing: AppSpacing.lg) {
                    Label("\(Int(set.weight)) kg", systemImage: "scalemass.fill")
                    Label("\(set.reps) reps", systemImage: "arrow.counterclockwise")
                }
                .font(AppFonts.subheadline)
                .foregroundStyle(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Taymer

    private var timerSection: some View {
        VStack(spacing: AppSpacing.lg) {

            // LED-üslublu rəqəmsal taymer
            Text(viewModel.timer.displayTime)
                .font(AppFonts.timerLarge)
                .foregroundStyle(accentColor)
                // LED glow effekti
                .shadow(color: accentColor.opacity(0.6), radius: 20, x: 0, y: 0)
                .shadow(color: accentColor.opacity(0.3), radius: 40, x: 0, y: 0)
                .monospacedDigit()
                .padding(AppSpacing.xxl)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.xl)
                        .fill(AppColors.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.xl)
                                .stroke(accentColor.opacity(0.2), lineWidth: 1)
                        )
                )

            // Dincəlmə zamanı +/- düymələri (Image 1-dəki minus/plus)
            if viewModel.workPhase == .resting {
                HStack(spacing: AppSpacing.xl) {
                    Button {
                        viewModel.timer.addTime(-15)
                    } label: {
                        Image(systemName: "minus")
                            .font(AppFonts.title2)
                            .foregroundStyle(AppColors.textSecondary)
                            .frame(width: 48, height: 48)
                            .background(AppColors.surface)
                            .cornerRadius(AppRadius.pill)
                    }

                    Text("Rest Time")
                        .font(AppFonts.caption)
                        .foregroundStyle(AppColors.textSecondary)

                    Button {
                        viewModel.timer.addTime(15)
                    } label: {
                        Image(systemName: "plus")
                            .font(AppFonts.title2)
                            .foregroundStyle(AppColors.textSecondary)
                            .frame(width: 48, height: 48)
                            .background(AppColors.surface)
                            .cornerRadius(AppRadius.pill)
                    }
                }
            }
        }
    }

    // MARK: - Alt düymə

    @ViewBuilder
    private var actionSection: some View {
        switch viewModel.workPhase {

        case .working:
            Button {
                Task { await viewModel.completeCurrentSet() }
            } label: {
                Text("Complete Set")
                    .font(AppFonts.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(AppSpacing.md)
                    .background(AppColors.primary)
                    .cornerRadius(AppRadius.pill)
            }

        case .resting:
            Button {
                viewModel.skipRest()
            } label: {
                Text("Skip Rest")
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(AppSpacing.md)
                    .background(AppColors.surfaceSecondary)
                    .cornerRadius(AppRadius.pill)
            }

        case .done:
            Button {
                router.goToRoot()
            } label: {
                Text("Workout Complete!")
                    .font(AppFonts.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(AppSpacing.md)
                    .background(AppColors.success)
                    .cornerRadius(AppRadius.pill)
            }
        }
    }
}
