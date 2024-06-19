//
//  HeartBeats38App.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz & Richard Rich on 4/4/24.
//

import SwiftUI
import FirebaseCore
import SwiftData

@main
struct HeartBeats38App: App {
    // Initialize FirebaseApp using AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var playerViewModel = PlayerViewModel()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if playerViewModel.videoCompleted {
                HomeView()
            } else {
                VideoPlayerView()
                    .environmentObject(playerViewModel)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

// AppDelegate for Firebase setup
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
