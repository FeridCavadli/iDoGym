import SwiftUI

@Observable
final class AppRouter {

    // NavigationStack-in izlədiyi ekran yığını
    // Boş başlayır — tək root ekran var
    var path = NavigationPath()

    // Tətbiqdə mövcud olan bütün ekranlar
    // Hashable — NavigationPath hər destination-ı tanıya bilsin
    enum Destination: Hashable {
        case workoutDetail(Workout)   // məşq detalları
        case activeWorkout(Workout)   // aktiv məşq + taymer
        case exercisePicker(Workout)   // hansı workout-a məşq əlavə ediləcək
    }

    // Yeni ekrana keç — yığına əlavə et
    func navigate(to destination: Destination) {
        path.append(destination)
    }

    // Bir addım geri qayıt
    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    // Birbaşa əsas ekrana qayıt (bütün yığını təmizlə)
    func goToRoot() {
        path.removeLast(path.count)
    }
}
