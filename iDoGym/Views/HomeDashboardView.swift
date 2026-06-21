import SwiftUI

struct HomeDashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    welcomeSection
                    nextSessionCard
                    bentoGrid
                    recommendedSection
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, AppSpacing.xl)
            }
            .background(AppColors.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Circle()
                        .fill(AppColors.textTertiary.opacity(0.3))
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

    // MARK: - Welcome

    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Good Morning,")
                .font(AppFonts.subheadline)
                .foregroundStyle(AppColors.textSecondary)
            Text("Alex")
                .font(AppFonts.largeTitle)
                .foregroundStyle(AppColors.textPrimary)
        }
    }

    // MARK: - Next Session Card

    private var nextSessionCard: some View {
        ZStack(alignment: .bottomTrailing) {
            // Dekorativ arxa dairə
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 160, height: 160)
                .blur(radius: 20)
                .offset(x: 32, y: 32)

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                // "NEXT SESSION" etiketi
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                    Text("NEXT SESSION")
                        .font(AppFonts.captionBold)
                        .foregroundStyle(.white.opacity(0.8))
                        .tracking(0.6)
                }

                Text("Full Body Power")
                    .font(AppFonts.body)
                    .foregroundStyle(.white)
                    .padding(.top, AppSpacing.sm)

                Text("45 Min • High Intensity")
                    .font(AppFonts.body)
                    .foregroundStyle(.white.opacity(0.9))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppSpacing.lg)
        }
        .background(AppColors.primary)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
    }

    // MARK: - Bento Grid (Progress Rings + Bar Chart)

    private var bentoGrid: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            progressRingsCard
            weeklyActivityCard
        }
    }

    // Sol kart: üç rəngli halqalar
    private var progressRingsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Today's Progress")
                .font(AppFonts.captionBold)
                .foregroundStyle(AppColors.textSecondary)
                .tracking(0.6)
                .padding([.top, .leading], AppSpacing.md)

            Spacer()

            // 3 iç-içə halqa
            ZStack {
                // Xarici — Cal (mavi)
                Circle()
                    .stroke(AppColors.primary.opacity(0.15), lineWidth: 12)
                Circle()
                    .trim(from: 0, to: 0.72)
                    .stroke(AppColors.primary, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                // Orta — Min (narıncı)
                Circle()
                    .stroke(Color(hex: "#FE9400").opacity(0.15), lineWidth: 12)
                    .padding(18)
                Circle()
                    .trim(from: 0, to: 0.55)
                    .stroke(Color(hex: "#FE9400"), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .padding(18)

                // Daxili — WO (yaşıl)
                Circle()
                    .stroke(Color(hex: "#008733").opacity(0.15), lineWidth: 12)
                    .padding(36)
                Circle()
                    .trim(from: 0, to: 0.40)
                    .stroke(Color(hex: "#008733"), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .padding(36)
            }
            .frame(width: 110, height: 110)
            .padding(.horizontal, AppSpacing.md)

            Spacer()

            // Rəng izahatı
            HStack(spacing: AppSpacing.sm) {
                legendDot(color: AppColors.primary, label: "Cal")
                legendDot(color: Color(hex: "#FE9400"), label: "Min")
                legendDot(color: Color(hex: "#008733"), label: "WO")
            }
            .padding([.bottom, .leading], AppSpacing.md)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 224)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
    }

    private func legendDot(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label)
                .font(AppFonts.captionBold)
                .foregroundStyle(AppColors.textPrimary)
                .tracking(0.6)
        }
    }

    private let weekDays = ["M", "T", "W", "T", "F", "S", "S"]
    private let barHeights: [CGFloat] = [48, 72, 86, 96, 58, 38, 67]
    private let todayIndex = 3

    // Sağ kart: həftəlik fəaliyyət çubuqları
    private var weeklyActivityCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Weekly")
                        .font(AppFonts.captionBold)
                        .foregroundStyle(AppColors.textSecondary)
                        .tracking(0.6)
                    Text("Activity")
                        .font(AppFonts.captionBold)
                        .foregroundStyle(AppColors.textSecondary)
                        .tracking(0.6)
                }
                Spacer()
                Text("Details")
                    .font(AppFonts.captionBold)
                    .foregroundStyle(AppColors.primary)
                    .tracking(0.6)
            }
            .padding([.top, .horizontal], AppSpacing.md)

            Spacer()

            HStack(alignment: .bottom, spacing: 4) {
                ForEach(0..<weekDays.count, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(i == todayIndex ? AppColors.primary : Color(hex: "#E9E7ED"))
                        .frame(height: barHeights[i])
                        .shadow(color: i == todayIndex ? AppColors.primary.opacity(0.4) : .clear,
                                radius: 4, y: 2)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppSpacing.md)

            HStack(spacing: 0) {
                ForEach(0..<weekDays.count, id: \.self) { i in
                    Text(weekDays[i])
                        .font(.system(size: 10))
                        .fontWeight(i == todayIndex ? .bold : .regular)
                        .foregroundStyle(i == todayIndex ? AppColors.textPrimary : AppColors.textTertiary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.top, AppSpacing.sm)
            .padding(.bottom, AppSpacing.md)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 224)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
    }

    // MARK: - Recommended For You

    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("Recommended for You")
                    .font(AppFonts.body)
                    .foregroundStyle(AppColors.textPrimary)
                Spacer()
                Text("See All")
                    .font(AppFonts.captionBold)
                    .foregroundStyle(AppColors.primary)
                    .tracking(0.6)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    recommendedCard(title: "Kettlebell Core",
                                    subtitle: "20 Min • Intermediate",
                                    badge: "Strength",
                                    color: Color(hex: "#5B4E6D"))
                    recommendedCard(title: "Morning Mobility",
                                    subtitle: "15 Min • Beginner",
                                    badge: "Yoga",
                                    color: Color(hex: "#4A7C6B"))
                    recommendedCard(title: "HIIT Cardio",
                                    subtitle: "30 Min • Advanced",
                                    badge: "Cardio",
                                    color: Color(hex: "#6B4E4E"))
                }
                .padding(.horizontal, 2)
            }
        }
    }

    private func recommendedCard(title: String, subtitle: String, badge: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(color)
                    .frame(height: 128)

                Text(badge)
                    .font(.system(size: 10))
                    .foregroundStyle(AppColors.textPrimary)
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .padding(AppSpacing.sm)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.textPrimary)
                Text(subtitle)
                    .font(AppFonts.subheadline)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding(AppSpacing.md)
        }
        .frame(width: 200)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
    }
}

#Preview {
    HomeDashboardView()
}
