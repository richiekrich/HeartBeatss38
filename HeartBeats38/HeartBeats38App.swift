//
//  HeartBeats38App.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz & Richard Rich on 4/4/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestoreSwift
import SwiftData

@main
struct HeartBeats38App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var playerViewModel = PlayerViewModel()
    @State private var sharedModelContainer: ModelContainer?

    var body: some Scene {
        WindowGroup {
            if let sharedModelContainer = sharedModelContainer {
                if playerViewModel.videoCompleted {
                    HomeView()
                        .modelContainer(sharedModelContainer)
                } else {
                    VideoPlayerView()
                        .environmentObject(playerViewModel)
                        .modelContainer(sharedModelContainer)
                }
            } else {
                Text("Loading...")
                    .onAppear {
                        loadModelContainer()
                    }
            }
        }
    }

    private func loadModelContainer() {
        DispatchQueue.global(qos: .background).async {
            let schema = Schema([
                Item.self,
            ])
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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        DispatchQueue.global(qos: .background).async {
            FirebaseApp.configure()
            print("Firebase configured successfully")
        }
        return true
    }
}
