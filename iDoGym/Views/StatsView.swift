import SwiftUI

struct StatsView: View {

    @State private var selectedPeriod = "Monthly"
    private let periods = ["Weekly", "Monthly"]

    private let days = ["S", "M", "T", "W", "T", "F", "S"]
    private let barHeights: [CGFloat] = [70, 105, 52, 140, 87, 122, 78]
    private let todayBar = 3

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    headerSection
                    metricsGrid
                    activityTrendsCard
                    workoutLogCard
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, AppSpacing.xxl)
            }
            .background(AppColors.background)
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Your Progress")
                .font(AppFonts.title)
                .foregroundStyle(AppColors.textPrimary)
            Text("Track your journey and stay consistent.")
                .font(AppFonts.body)
                .foregroundStyle(AppColors.textSecondary)
        }
    }

    // MARK: - Metrics Grid (2x2 + 2 full-width)

    private var metricsGrid: some View {
        VStack(spacing: AppSpacing.md) {
            // Üst sıra: 2 kiçik kart
            HStack(spacing: AppSpacing.md) {
                smallMetricCard(
                    icon: "flame.fill",
                    iconColor: Color(hex: "#8C5000"),
                    glowColor: Color(hex: "#8C5000").opacity(0.1),
                    label: "STREAK",
                    value: "12",
                    unit: "days"
                )
                smallMetricCard(
                    icon: "figure.strengthtraining.traditional",
                    iconColor: AppColors.primary,
                    glowColor: AppColors.primary.opacity(0.1),
                    label: "WORKOUTS",
                    value: "48",
                    unit: "total"
                )
            }

            // Tamamlanma faizi
            completionCard

            // Kalori
            caloriesCard
        }
    }

    private func smallMetricCard(icon: String, iconColor: Color, glowColor: Color,
                                  label: String, value: String, unit: String) -> some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(glowColor)
                .frame(width: 64, height: 64)
                .blur(radius: 12)
                .offset(x: 16, y: 16)

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    Image(systemName: icon)
                        .foregroundStyle(iconColor)
                    Spacer()
                    Text(label)
                        .font(AppFonts.captionBold)
                        .tracking(0.6)
                        .foregroundStyle(AppColors.textSecondary)
                }

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value)
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(AppColors.textPrimary)
                        .tracking(-0.96)
                    Text(unit)
                        .font(AppFonts.subheadline)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .padding(AppSpacing.md)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
        .clipped()
    }

    private var completionCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(AppColors.success)
                Spacer()
                Text("COMPLETION")
                    .font(AppFonts.captionBold)
                    .tracking(0.6)
                    .foregroundStyle(AppColors.textSecondary)
            }

            HStack(alignment: .bottom, spacing: AppSpacing.sm) {
                Text("85%")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                    .tracking(-0.96)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(hex: "#E9E7ED"))
                            .frame(height: 8)
                        Capsule()
                            .fill(Color(hex: "#006B27"))
                            .frame(width: geo.size.width * 0.85, height: 8)
                    }
                }
                .frame(height: 8)
                .padding(.bottom, 12)
            }
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 120)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
    }

    private var caloriesCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(Color(hex: "#F59E0B"))
                Spacer()
                Text("CALORIES")
                    .font(AppFonts.captionBold)
                    .tracking(0.6)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Text("24k")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(AppColors.textPrimary)
                .tracking(-0.96)

            Text("this month")
                .font(AppFonts.subheadline)
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 136)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
    }

    // MARK: - Activity Trends

    private var activityTrendsCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("Activity Trends")
                    .font(AppFonts.title2)
                    .foregroundStyle(AppColors.textPrimary)
                Spacer()
                HStack(spacing: AppSpacing.sm) {
                    ForEach(periods, id: \.self) { period in
                        Text(period)
                            .font(AppFonts.captionBold)
                            .tracking(0.6)
                            .foregroundStyle(selectedPeriod == period ? AppColors.primary : AppColors.textSecondary)
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(selectedPeriod == period
                                          ? AppColors.primary.opacity(0.1)
                                          : Color(hex: "#E3E2E7"))
                            )
                            .onTapGesture { selectedPeriod = period }
                    }
                }
            }

            // Bar chart
            VStack(spacing: 4) {
                HStack(alignment: .bottom, spacing: 0) {
                    // Y-axis
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("1000").font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(AppColors.textSecondary)
                        Spacer()
                        Text("500").font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(AppColors.textSecondary)
                        Spacer()
                        Text("0").font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    .frame(width: 36)
                    .frame(height: 160)
                    .padding(.bottom, 4)

                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(0..<days.count, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(i == todayBar
                                      ? AppColors.primary
                                      : AppColors.primary.opacity(0.3))
                                .frame(height: barHeights[i])
                                .frame(maxWidth: .infinity)
                                .shadow(color: i == todayBar ? AppColors.primary.opacity(0.4) : .clear,
                                        radius: 4)
                        }
                    }
                    .frame(height: 160)
                    .padding(.leading, 8)
                }

                // X-axis günlər
                HStack(spacing: 0) {
                    Spacer().frame(width: 44)
                    HStack(spacing: 8) {
                        ForEach(0..<days.count, id: \.self) { i in
                            Text(["Mon","Tue","Wed","Thu","Fri","Sat","Sun"][i])
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(AppColors.textSecondary)
                                .tracking(0.6)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
    }

    // MARK: - Workout Log

    private var workoutLogCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("Workout Log")
                    .font(AppFonts.title2)
                    .foregroundStyle(AppColors.textPrimary)
                Spacer()
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AppColors.textPrimary)
                    Text("OCTOBER")
                        .font(AppFonts.captionBold)
                        .tracking(0.6)
                        .foregroundStyle(AppColors.textPrimary)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AppColors.textPrimary)
                }
            }

            // Təqvim
            calendarGrid

            // Bugünkü məşq
            todayWorkoutRow
        }
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
    }

    private var calendarGrid: some View {
        let headers = ["S","M","T","W","T","F","S"]
        // Oktyabr 2024: 1-ci çərşənbə axşamı (col 2), tamamlanmış günlər
        let workoutDays: Set<Int> = [1, 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13]
        let startCol = 2 // 1 oktyabr bazar ertəsidir

        return VStack(spacing: 4) {
            // Həftə başlıqları
            HStack(spacing: 0) {
                ForEach(headers, id: \.self) { h in
                    Text(h)
                        .font(.system(size: 10))
                        .foregroundStyle(AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Günlər (sadə 3 sıra)
            let calDays: [[Int?]] = [
                [nil, nil, 1, 2, 3, 4, 5],
                [6, 7, 8, 9, 10, 11, 12],
                [13, 14, 15, nil, nil, nil, nil]
            ]

            ForEach(0..<calDays.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<7) { col in
                        if let day = calDays[row][col] {
                            let isWorkout = workoutDays.contains(day)
                            ZStack {
                                if isWorkout {
                                    Circle()
                                        .fill(AppColors.primary.opacity(0.15))
                                        .frame(width: 32, height: 32)
                                }
                                Text("\(day)")
                                    .font(.system(size: 15))
                                    .foregroundStyle(isWorkout ? AppColors.primary : AppColors.textPrimary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                        } else {
                            Color.clear
                                .frame(maxWidth: .infinity)
                                .frame(height: 36)
                        }
                    }
                }
            }
        }
    }

    private var todayWorkoutRow: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 40, height: 40)
                Image(systemName: "figure.run")
                    .foregroundStyle(AppColors.primary)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Today's Workout: HIIT Cardio")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(AppColors.textPrimary)
                Text("45 mins • 420 kcal burned • High Intensity")
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .padding(AppSpacing.md)
        .background(Color(hex: "#F4F3F8"))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))
    }
}

#Preview {
    StatsView()
}
