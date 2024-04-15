import Foundation
import Combine

class HeartRateViewModel: ObservableObject {
    @Published var heartRate: Double = 60.0  // Starting heart rate
    @Published var isWorkoutActive: Bool = false
    var timer: Timer?

    // Start simulating a workout heart rate
    func startHeartRateSimulation() {
        isWorkoutActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            // Simulate heart rate increase or decrease
            let fluctuation = Double.random(in: -5...15) // Adjust range based on desired simulation detail
            let newRate = self.heartRate + fluctuation
            // Keep the simulated heart rate within a typical workout range
            self.heartRate = min(max(newRate, 100), 180)
        }
    }

    // Stop the heart rate simulation
    func stopHeartRateSimulation() {
        isWorkoutActive = false
        timer?.invalidate()
        timer = nil
    }
}
