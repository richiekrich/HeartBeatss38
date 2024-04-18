import Foundation
import Combine

class HeartRateViewModel: ObservableObject {
    @Published var heartRate: Double = 60.0  // Starting heart rate
    @Published var isWorkoutActive: Bool = false
    var timer: Timer?

    // Start simulating a workout heart rate
    func startHeartRateSimulation() {
        isWorkoutActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            // Simulate heart rate increase
            let fluctuation = Double.random(in: -1...5)  // Random fluctuation to simulate a varying heart rate
            let newRate = self.heartRate + fluctuation
            // Keep the simulated heart rate within a typical workout range
            self.heartRate = min(max(newRate, 100), 180)
        }
    }
    func pauseWorkout() {
        timer?.invalidate()
        isWorkoutActive = false  // Optionally keep this true if pause should indicate an active but paused state
    }
    
    // Stop the heart rate simulation
    func stopHeartRateSimulation() {
        isWorkoutActive = false
        timer?.invalidate()
        timer = nil
        heartRate = 60.0
    }

    // Restart the workout
    func restartWorkout() {
        stopHeartRateSimulation()  // Stop any existing workout simulation
        startHeartRateSimulation()
        heartRate = 60.0  // Reset heart rate back to starting value
    }
}
