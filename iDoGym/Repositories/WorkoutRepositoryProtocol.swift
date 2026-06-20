import Foundation

// Protokol — "nə edə bilərik?" sualının cavabı
// ViewModel yalnız bunu görür, arxada SwiftData-mı, API-mi — bilmir
protocol WorkoutRepositoryProtocol {

    // Bütün workout-ları gətir (ən yenidən ən köhnəyə)
    func fetchAll() async throws -> [Workout]

    // Yeni workout əlavə et
    func save(_ workout: Workout) async throws

    // Workout-u sil
    func delete(_ workout: Workout) async throws
}
