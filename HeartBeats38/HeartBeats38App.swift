import SwiftUI
import FirebaseCore
import FirebaseFirestoreSwift
import SwiftData

@main
struct HeartBeats38App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var playerViewModel = PlayerViewModel()
    @StateObject private var workoutsViewModel = WorkoutsViewModel(firestoreService: FirestoreService())
    @State private var sharedModelContainer: ModelContainer?

    var body: some Scene {
        WindowGroup {
            if let sharedModelContainer = sharedModelContainer {
                if playerViewModel.videoCompleted {
                    HomeView()
                        .environmentObject(workoutsViewModel)
                        .modelContainer(sharedModelContainer)
                } else {
                    VideoPlayerView()
                        .environmentObject(playerViewModel)
                        .modelContainer(sharedModelContainer)
                }
            } else {
                SplashScreen()
                    .onAppear {
                        loadModelContainer()
                    }
            }
        }
    }

    private func loadModelContainer() {
        DispatchQueue.global(qos: .background).async {
            let schema = Schema([Item.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            do {
                let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
                DispatchQueue.main.async {
                    sharedModelContainer = container
                }
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }
}
