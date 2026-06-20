import SwiftUI
import SwiftData

@main
struct iDoGymApp: App {

    var sharedModelContainer: ModelContainer = {
        // Bütün @Model class-larımızı burada qeydiyyatdan keçiririk
        let schema = Schema([
            Workout.self,
            ExerciseLog.self,
            Exercise.self,
            ExerciseSet.self,
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("ModelContainer yaradıla bilmədi: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
