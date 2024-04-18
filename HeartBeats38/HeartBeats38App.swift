//
//  HeartBeats38App.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz on 4/4/24.
//

import SwiftUI
import SwiftData

@main
struct HeartBeats38App: App {
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
