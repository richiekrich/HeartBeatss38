import SwiftUI
import AVFoundation

struct WorkoutView: View {
    @ObservedObject var audioPlayerManager: AudioPlayerManager
    @StateObject private var viewModel = HeartRateViewModel()
    var selectedFile: String

    @State private var statusMessage = ""
    @State private var isWorkoutActive = false
    @State private var countdown = 3
    @State private var showCountdown = false
    @State private var buttonOpacity = 1.0
    @State private var elapsedTime = 0
    @State private var elapsedTimeTimer: Timer?

    var body: some View {
        VStack {
            Text("Elapsed Workout Time: \(elapsedTime) seconds")
                .foregroundColor(.black)
                .padding()

            Text("Heart Rate: \(viewModel.heartRate, specifier: "%.1f") BPM")
                .foregroundColor(.black)
            Text(statusMessage)
                .foregroundColor(.black)
                .padding()

            if showCountdown {
                Text("Workout starting in... \(countdown)")
                    .foregroundColor(.black)
                    .font(.title)
                    .transition(.scale)
            }

            if !isWorkoutActive {
                Button(action: startWorkout) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .opacity(buttonOpacity)
                }
            } else {
                Button(action: stopWorkout) {
                    Image(systemName: "stop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
                Button(action: pauseWorkout) {
                    Image(systemName: "pause.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
                Button("Resume Workout", action: resumeWorkout)
                    .buttonStyle(PrimaryButtonStyle(isDisabled: !viewModel.isWorkoutActive, backgroundColor: .green, textColor: .white))
            }
        }
        .onAppear {
            audioPlayerManager.loadAudioFile(fileName: selectedFile)
        }
        .onChange(of: viewModel.heartRate) { oldRate, newRate in
            audioPlayerManager.adjustPlaybackRate(basedOnHeartRate: newRate)
        }
    }

    func startWorkout() {
        showCountdown = true
        countdown = 3
        elapsedTime = 0
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
                withAnimation(.easeInOut(duration: 0.5)) {
                    buttonOpacity = 0.1
                }
                withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                    buttonOpacity = 1.0
                }
            } else {
                timer.invalidate()
                showCountdown = false
                viewModel.startHeartRateSimulation()
                statusMessage = "Workout started."
                audioPlayerManager.play()
                isWorkoutActive = true
                startElapsedTimeTimer()
            }
        }
    }

    func resumeWorkout() {
        viewModel.startHeartRateSimulation()
        startElapsedTimeTimer()
        statusMessage = "Workout resumed."
        isWorkoutActive = true
    }

    func pauseWorkout() {
        viewModel.pauseWorkout()
        statusMessage = "Workout paused."
        stopElapsedTimeTimer()
    }

    func stopWorkout() {
        viewModel.stopHeartRateSimulation()
        statusMessage = "Workout stopped."
        audioPlayerManager.stop()
        isWorkoutActive = false
        stopElapsedTimeTimer()
    }

    func startElapsedTimeTimer() {
        stopElapsedTimeTimer()
        elapsedTimeTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime += 1
        }
    }

    func stopElapsedTimeTimer() {
        elapsedTimeTimer?.invalidate()
        elapsedTimeTimer = nil
    }
}
