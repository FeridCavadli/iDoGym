import SwiftUI

struct ContentView: View {

    @State private var selectedTab: Tab = .home

    enum Tab {
        case home, programs, workout, stats, profile
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeDashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)

            ProgramsView()
                .tabItem {
                    Label("Programs", systemImage: "dumbbell.fill")
                }
                .tag(Tab.programs)

            ActiveWorkoutView()
                .tabItem {
                    Label("Workout", systemImage: "play.circle.fill")
                }
                .tag(Tab.workout)

            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(Tab.stats)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .tint(AppColors.primary)
    }
}
