import Foundation

protocol ExerciseRepositoryProtocol {
    func fetchAll() async throws -> [Exercise]
    func save(_ exercise: Exercise) async throws
    // App ilk açılanda boş bazaya default məşqlər yaz
    func seedDefaultsIfNeeded() async throws
}
