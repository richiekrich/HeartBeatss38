import SwiftUI
import Combine

import SwiftUI
import Combine

class WorkoutsViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    private var firestoreService = FirestoreService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadWorkouts()
    }

    func loadWorkouts() {
        firestoreService.fetchWorkouts { result in
            switch result {
            case .success(let workouts):
                DispatchQueue.main.async {
                    self.workouts = workouts
                }
            case .failure(let error):
                print("Error fetching workouts: \(error)")
            }
        }
    }

    func addWorkout(_ workout: Workout) {
        firestoreService.addWorkout(workout) { result in
            switch result {
            case .success():
                self.loadWorkouts()
            case .failure(let error):
                print("Error adding workout: \(error)")
            }
        }
    }
}
