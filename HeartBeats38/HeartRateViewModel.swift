import SwiftUI
import Combine

class HeartRateViewModel: ObservableObject {
    @Published var heartRate: Double = 60.0
    @Published var isWorkoutActive: Bool = false
    private var timer: Timer?
    private let heartRateRange: ClosedRange<Double> = 60...180
    private let bpmIncrement: Double = 20.0 / 10.0  // 20 bpm every 10 seconds
    private var isIncreasing = true

    func startHeartRateSimulation() {
        isWorkoutActive = true
        heartRate = heartRateRange.lowerBound
        isIncreasing = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateHeartRate()
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
