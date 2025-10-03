import SwiftUI
import StateModel

@main
struct StateModelExampleApp: App {

    /**
     The database to use within the app.

     A simple in-memory database is used for demonstration, but it's possible to drop any `Database` implementation.
     The database is wrapped in `ObservableDatabase` to provide the mechanisms for SwiftUI updates.
     */
    let database = ObservableDatabase(wrapping: InMemoryDatabase())

    var body: some Scene {
        WindowGroup {
            ContentView()
                // The database is added as an environment object for all views,
                // so that queries can access it.
                .environmentObject(database)
        }
    }
}
