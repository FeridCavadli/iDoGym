import SwiftUI

struct ContentView: View {

    @Environment(DependencyContainer.self) private var dependencies
    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var router = router
        TabView(selection: $router.selectedTab) {
            HomeDashboardView(repository: dependencies.workoutRepository)
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(AppRouter.AppTab.home)

            ProgramsView()
                .tabItem { Label("Programs", systemImage: "dumbbell.fill") }
                .tag(AppRouter.AppTab.programs)

            WorkoutTabView(
                workoutRepository: dependencies.workoutRepository,
                exerciseRepository: dependencies.exerciseRepository
            )
            .tabItem { Label("Workout", systemImage: "play.circle.fill") }
            .tag(AppRouter.AppTab.workout)

            StatsView(repository: dependencies.workoutRepository)
                .tabItem { Label("Stats", systemImage: "chart.bar.fill") }
                .tag(AppRouter.AppTab.stats)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(AppRouter.AppTab.profile)
        }
        .tint(AppColors.primary)
    }
}
