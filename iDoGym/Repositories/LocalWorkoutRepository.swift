import Foundation
import SwiftData

final class LocalWorkoutRepository: WorkoutRepositoryProtocol {

    // ModelContext — SwiftData ilə danışmaq üçün əsas alət
    // Baza əməliyyatları (əlavə et, sil, fetch) buradan keçir
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() async throws -> [Workout] {
        // Hansı tipi fetch edəcəyimizi və sıralanmanı müəyyən edirik
        let descriptor = FetchDescriptor<Workout>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    func save(_ workout: Workout) async throws {
        context.insert(workout)
        try context.save()
    }

    func delete(_ workout: Workout) async throws {
        context.delete(workout)
        try context.save()
    }
}
