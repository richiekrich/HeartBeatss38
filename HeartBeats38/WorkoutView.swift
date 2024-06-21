import SwiftUI

struct WorkoutView: View {
    @StateObject private var heartRateViewModel = HeartRateViewModel()
    @ObservedObject var audioPlayerManager: AudioPlayerManager
    @EnvironmentObject var playerViewModel: PlayerViewModel

    var body: some View {
        ZStack {
            if heartRateViewModel.isWorkoutActive && !playerViewModel.videoCompleted {
                VideoPlayerView()
                    .ignoresSafeArea()
            }

            VStack {
                if let currentFileName = audioPlayerManager.currentFileName {
                    Text("Now Playing: \(currentFileName)")
                        .font(.headline)
                        .padding()
                } else {
                    Text("No Track Selected")
                        .font(.headline)
                        .padding()
                }

                Text("Workout View")
                Text("Heart Rate: \(heartRateViewModel.heartRate, specifier: "%.1f") BPM")
                    .padding()

                AudioPlayerView(audioPlayerManager: audioPlayerManager)
                    .padding()

                if heartRateViewModel.isWorkoutActive {
                    Button("Pause Workout") {
                        heartRateViewModel.pauseWorkout()
                        audioPlayerManager.pause()
                    }
                } else {
                    Button("Resume Workout") {
                        heartRateViewModel.startHeartRateSimulation()
                        audioPlayerManager.play()
                    }
                }

                if !heartRateViewModel.isWorkoutActive {
                    Button(action: startWorkout) {
                        Text("Start Workout")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            heartRateViewModel.startHeartRateSimulation()
        }
        .onDisappear {
            heartRateViewModel.stopHeartRateSimulation()
            audioPlayerManager.stop()
        }
    }

    private func startWorkout() {
        heartRateViewModel.startHeartRateSimulation()
        audioPlayerManager.play()
        heartRateViewModel.isWorkoutActive = true
        playerViewModel.videoCompleted = false // Reset video state if necessary
    }
}
