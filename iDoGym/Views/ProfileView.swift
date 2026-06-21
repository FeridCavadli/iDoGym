import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    profileHeader
                    personalInfoSection
                    fitnessGoalsSection
                    editButton
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xxl)
            }
            .background(AppColors.background)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Profile Header

    private var profileHeader: some View {
        VStack(spacing: AppSpacing.sm) {
            // Şəkil (gradient haşiyə)
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primary, Color(hex: "#ADC6FF")],
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                    )
                    .frame(width: 128, height: 128)
                    .overlay(
                        Circle()
                            .fill(Color(hex: "#FAF9FE"))
                            .padding(3)
                            .overlay(
                                Circle()
                                    .fill(AppColors.textSecondary.opacity(0.2))
                                    .padding(5)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 48))
                                            .foregroundStyle(AppColors.textSecondary)
                                    )
                            )
                    )

                // Foto dəyişdir düyməsi
                Button {} label: {
                    Circle()
                        .fill(AppColors.primary)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.white)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
                }
            }

            Text("Alex")
                .font(AppFonts.title)
                .foregroundStyle(AppColors.textPrimary)

            Text("Free Member")
                .font(.system(size: 16))
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Personal Info

    private var personalInfoSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            sectionLabel("PERSONAL INFO")

            VStack(spacing: 0) {
                infoRow(icon: "figure.stand", label: "Age", value: "28")
                Divider().padding(.leading, 60)
                infoRow(icon: "person.fill", label: "Gender", value: "Male")
            }
            .background(AppColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .cardShadow()
        }
    }

    // MARK: - Fitness Goals

    private var fitnessGoalsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            sectionLabel("FITNESS GOALS")

            HStack(spacing: AppSpacing.md) {
                goalCard(
                    iconBg: Color(hex: "#FFDCBF"),
                    icon: "figure.strengthtraining.traditional",
                    iconColor: Color(hex: "#8C5000"),
                    label: "PRIMARY GOAL",
                    value: "Build Muscle",
                    unit: nil
                )
                goalCard(
                    iconBg: Color(hex: "#72FE88"),
                    icon: "scalemass.fill",
                    iconColor: Color(hex: "#006B27"),
                    label: "TARGET WEIGHT",
                    value: "85",
                    unit: "kg"
                )
            }
        }
    }

    // MARK: - Edit Button

    private var editButton: some View {
        Button {} label: {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "pencil")
                    .font(.system(size: 16))
                Text("Edit Profile")
                    .font(.system(size: 22, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(AppColors.primary)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .shadow(color: AppColors.primary.opacity(0.25), radius: 7, y: 4)
        }
        .padding(.top, AppSpacing.sm)
    }

    // MARK: - Helpers

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(AppFonts.captionBold)
            .tracking(0.6)
            .foregroundStyle(AppColors.textTertiary)
            .padding(.leading, 4)
    }

    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppRadius.sm)
                        .fill(Color(hex: "#F4F3F8"))
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundStyle(AppColors.textSecondary)
                }
                Text(label)
                    .font(.system(size: 16))
                    .foregroundStyle(AppColors.textPrimary)
            }
            Spacer()
            Text(value)
                .font(.system(size: 16))
                .foregroundStyle(AppColors.textSecondary)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.md)
        .background(AppColors.surface)
    }

    private func goalCard(iconBg: Color, icon: String, iconColor: Color,
                           label: String, value: String, unit: String?) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack {
                Circle().fill(iconBg).frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundStyle(iconColor)
            }
            .padding(.bottom, 4)

            Text(label)
                .font(AppFonts.captionBold)
                .tracking(0.6)
                .foregroundStyle(AppColors.textSecondary)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(AppColors.textPrimary)
                if let unit {
                    Text(unit)
                        .font(AppFonts.subheadline)
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.md)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .cardShadow()
    }
}

#Preview {
    ProfileView()
}
