//
//  WorkoutsViewModel.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz on 4/18/24.
//

import SwiftUI
import Combine

class WorkoutsViewModel: ObservableObject {
    @Published var workouts: [Workout] = []

    init() {
        loadWorkouts()
    }

    func loadWorkouts() {
        // Here, load your workouts from a database or local storage
        // For demonstration, let's use static data
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        workouts = [
            Workout(name: "Morning Run", duration: "30 mins", date: formatter.date(from: "04/18/2024")!, avgHeartBeat: 120),
            Workout(name: "Afternoon Jog", duration: "45 mins", date: formatter.date(from: "04/17/2024")!, avgHeartBeat: 110),
            Workout(name: "Cycling", duration: "60 mins", date: formatter.date(from: "04/16/2024")!, avgHeartBeat: 130)
        ]
    }
}


