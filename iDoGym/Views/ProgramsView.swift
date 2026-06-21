import SwiftUI

struct ProgramsView: View {

    @Environment(AppRouter.self) private var router
    @State private var selectedFilter = "All Programs"

    private let filters = ["All Programs", "Weight Loss", "Muscle Gain", "Beginner", "Pro"]

    private let programs: [ProgramItem] = [
        ProgramItem(
            title: "Powerlifting Foundations",
            description: "Build serious strength with this comprehensive program focusing on the big lifts.",
            weeks: 8,
            badge: "Pro",
            badgeIcon: "star.fill",
            goal: "Muscle Gain",
            goalIcon: "figure.strengthtraining.traditional",
            duration: "45-60 min/day",
            color: Color(hex: "#2D3A4A")
        ),
        ProgramItem(
            title: "Cardio Kickstart",
            description: "A gentle introduction to cardiovascular fitness, designed to burn calories and build a solid base.",
            weeks: 4,
            badge: "Beginner",
            badgeIcon: "leaf.fill",
            goal: "Weight Loss",
            goalIcon: "flame.fill",
            duration: "20-30 min/day",
            color: Color(hex: "#3A7CA5")
        ),
        ProgramItem(
            title: "Core & Flexibility",
            description: "Improve your posture, balance, and core strength with a mix of dynamic stretching and stability work.",
            weeks: 6,
            badge: "Intermediate",
            badgeIcon: "person.fill",
            goal: "Mobility",
            goalIcon: "figure.flexibility",
            duration: "30-40 min/day",
            color: Color(hex: "#4A3728")
        )
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Başlıq
                    VStack(spacing: AppSpacing.sm) {
                        Text("Explore Programs")
                            .font(AppFonts.title)
                            .foregroundStyle(AppColors.textPrimary)
                            .multilineTextAlignment(.center)

                        Text("Find the perfect workout plan to achieve\nyour fitness goals.")
                            .font(AppFonts.body)
                            .foregroundStyle(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, AppSpacing.md)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.bottom, AppSpacing.lg)

                    // Öz proqramını yarat banner
                    createOwnBanner
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.bottom, AppSpacing.sm)

                    // Filter chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppSpacing.sm) {
                            ForEach(filters, id: \.self) { filter in
                                filterChip(filter)
                            }
                        }
                        .padding(.horizontal, AppSpacing.md)
                    }
                    .padding(.bottom, AppSpacing.lg)

                    // Program kartları
                    VStack(spacing: AppSpacing.md) {
                        ForEach(programs) { program in
                            programCard(program)
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.bottom, AppSpacing.xxl)
                }
            }
            .background(AppColors.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Circle()
                        .fill(Color(hex: "#E3E2E7"))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(AppColors.textSecondary)
                        )
                }
                ToolbarItem(placement: .principal) {
                    Text("iDoGym")
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.primary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "gearshape")
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
    }

        // MARK: - Create Own Banner

    private var createOwnBanner: some View {
        Button {
            router.selectedTab = .workout
            router.shouldShowCreateWorkout = true
        } label: {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 48, height: 48)
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Create your own program")
                        .font(AppFonts.headline)
                        .foregroundStyle(.white)
                    Text("Hərəkətlərini özün seç və başla")
                        .font(AppFonts.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding(AppSpacing.md)
            .background(AppColors.primary)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .shadow(color: AppColors.primary.opacity(0.3), radius: 8, y: 4)
        }
    }

    // MARK: - Filter Chip

    @ViewBuilder
    private func filterChip(_ title: String) -> some View {
        let isActive = selectedFilter == title
        Text(title)
            .font(AppFonts.captionBold)
            .tracking(0.6)
            .foregroundStyle(isActive ? AppColors.primary : AppColors.textSecondary)
            .padding(.horizontal, 17)
            .padding(.vertical, 9)
            .background(
                Capsule()
                    .fill(isActive ? AppColors.primary.opacity(0.1) : Color(hex: "#FAF9FE"))
                    .overlay(
                        Capsule()
                            .stroke(
                                isActive ? AppColors.primary : Color(hex: "#C1C6D7"),
                                lineWidth: 1
                            )
                    )
            )
            .onTapGesture {
                selectedFilter = title
            }
    }

    // MARK: - Program Card

    @ViewBuilder
    private func programCard(_ program: ProgramItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Şəkil sahəsi
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(program.color)
                    .frame(height: 192)

                // Badge (sol üst)
                HStack(spacing: 4) {
                    Image(systemName: program.badgeIcon)
                        .font(.system(size: 10))
                        .foregroundStyle(AppColors.textPrimary)
                    Text(program.badge)
                        .font(AppFonts.captionBold)
                        .tracking(0.6)
                        .foregroundStyle(AppColors.textPrimary)
                }
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(AppSpacing.sm)
            }

            // Mətn sahəsi
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                // Ad + həftə
                HStack(alignment: .top) {
                    Text(program.title)
                        .font(.system(size: 16))
                        .foregroundStyle(AppColors.textPrimary)
                    Spacer()
                    Text("\(program.weeks) Weeks")
                        .font(AppFonts.captionBold)
                        .tracking(0.6)
                        .foregroundStyle(AppColors.textSecondary)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, 4)
                        .background(Color(hex: "#E3E2E7"))
                        .clipShape(Capsule())
                }

                // Açıqlama
                Text(program.description)
                    .font(AppFonts.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(2)

                // Alt etiketlər
                HStack(spacing: AppSpacing.md) {
                    Label(program.goal, systemImage: program.goalIcon)
                        .font(AppFonts.captionBold)
                        .tracking(0.6)
                        .foregroundStyle(AppColors.primary)

                    Label(program.duration, systemImage: "clock")
                        .font(AppFonts.captionBold)
                        .tracking(0.6)
                        .foregroundStyle(AppColors.textSecondary)
                }
                .padding(.top, AppSpacing.xs)
            }
            .padding(AppSpacing.md)
        }
        .background(Color(hex: "#FAF9FE"))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
    }
}

// MARK: - Model

struct ProgramItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let weeks: Int
    let badge: String
    let badgeIcon: String
    let goal: String
    let goalIcon: String
    let duration: String
    let color: Color
}

#Preview {
    ProgramsView()
        .environment(AppRouter())
}
