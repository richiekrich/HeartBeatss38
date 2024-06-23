import Combine
import SwiftUI

class HeartRateViewModel: ObservableObject {
    @Published var heartRate: Double = 60.0
    @Published var isWorkoutActive: Bool = false
    private var timer: Timer?
    private let heartRateRange: ClosedRange<Double> = 60...180
    private let bpmIncrement: Double = 2.0  // Adjust this increment to change heart rate more slowly
    private var isIncreasing = true
    private var heartRateReadings: [Double] = []

    func startHeartRateSimulation() {
        isWorkoutActive = true
        heartRate = heartRateRange.lowerBound
        isIncreasing = true
        heartRateReadings = [] // Clear previous readings
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateHeartRate()
            self.heartRateReadings.append(self.heartRate) // Store the heart rate reading
        }
    }

    func pauseWorkout() {
        timer?.invalidate()
        timer = nil
        isWorkoutActive = false
    }

    func stopHeartRateSimulation() {
        timer?.invalidate()
        timer = nil
        isWorkoutActive = false
        heartRate = 60.0
    }

    func calculateAverageHeartRate() -> Double {
        guard !heartRateReadings.isEmpty else { return 0.0 }
        let totalHeartRate = heartRateReadings.reduce(0, +)
        return totalHeartRate / Double(heartRateReadings.count)
    }

    private func updateHeartRate() {
        if isIncreasing {
            heartRate += bpmIncrement
            if heartRate >= heartRateRange.upperBound {
                heartRate = heartRateRange.upperBound
                isIncreasing = false
            }
        } else {
            heartRate -= bpmIncrement
            if heartRate <= heartRateRange.lowerBound {
                heartRate = heartRateRange.lowerBound
                isIncreasing = true
            }
        }
    }
}
