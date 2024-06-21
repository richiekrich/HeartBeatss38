import SwiftUI
import Combine

class HeartRateViewModel: ObservableObject {
    @Published var heartRate: Double = 0.0
    @Published var isWorkoutActive: Bool = false
    private var timer: Timer?

    func startHeartRateSimulation() {
        isWorkoutActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.heartRate = Double.random(in: 60...180)
        }
    }

    func stopHeartRateSimulation() {
        isWorkoutActive = false
        timer?.invalidate()
        timer = nil
    }

    func pauseWorkout() {
        timer?.invalidate()
    }
}
