import SwiftUI
import SwiftData

@main
struct iDoGymApp: App {

    private let modelContainer: ModelContainer
    private let dependencies: DependencyContainer
    private let router = AppRouter()

    init() {
        let schema = Schema([
            Workout.self,
            ExerciseLog.self,
            Exercise.self,
            ExerciseSet.self,
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            // 1. SwiftData konteynerini yarat
            let container = try ModelContainer(for: schema, configurations: [config])
            self.modelContainer = container

            // 2. ModelContext-i DependencyContainer-a ver
            // mainContext — əsas (UI) thread-in context-idir
            self.dependencies = DependencyContainer(modelContext: container.mainContext)
        } catch {
            fatalError("ModelContainer yaradıla bilmədi: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dependencies)
                .environment(router)
                .preferredColorScheme(.light)
        }
        .modelContainer(modelContainer)
    }
}
