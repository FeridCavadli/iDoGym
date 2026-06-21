import SwiftUI

@Observable
final class AppRouter {

    // Tab seçimi — istənilən view-dan dəyişdirilə bilər
    var selectedTab: AppTab = .home
    // Programs-dan Workout-a keçəndə create alert-i göstər
    var shouldShowCreateWorkout = false

    enum AppTab {
        case home, programs, workout, stats, profile
    }

    enum Destination: Hashable {
        case workoutDetail(Workout)
        case activeWorkout(Workout)
        case exercisePicker(Workout)
    }

    var path = NavigationPath()

    func navigate(to destination: Destination) {
        path.append(destination)
    }

    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func goToRoot() {
        path.removeLast(path.count)
    }
}
