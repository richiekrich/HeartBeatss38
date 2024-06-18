import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var viewModel = HeartRateViewModel()
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    @State private var statusMessage = ""
    @State private var isWorkoutActive = false
    @State private var isAudioPlaying = false
    @State private var countdown = 3
    @State private var showCountdown = false
    @State private var buttonOpacity = 1.0
    @State private var elapsedTime = 0
    @State private var elapsedTimeTimer: Timer?

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

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
                        Image("heartPlay")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .opacity(buttonOpacity)
                    }
                }

                if isWorkoutActive {
                    Button(action: stopWorkout) {
                        Image("heartStop")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                    Button(action: pauseWorkout) {
                        Image("pause")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                    Button("Resume Workout", action: resumeWorkout)
                        .buttonStyle(PrimaryButtonStyle(isDisabled: !viewModel.isWorkoutActive, backgroundColor: .green, textColor: .white))
                }
            }
            .onChange(of: viewModel.heartRate) { oldRate, newRate in
                audioPlayerManager.adjustPlaybackRate(basedOnHeartRate: newRate)
            }
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

    func restartWorkout() {
        stopWorkout()
        stopElapsedTimeTimer()       // Stop the elapsed time timer.
        elapsedTime = 0              // Reset the elapsed time to 0.
        statusMessage = "Workout restarted."
        isWorkoutActive = false
        isAudioPlaying = false
        startWorkout()               // Optionally, automatically start the workout again.
    }

    func resumeWorkout() {
        viewModel.startHeartRateSimulation()  // Assumes this function can handle resuming
        startElapsedTimeTimer()  // Resume the elapsed time timer
        statusMessage = "Workout resumed."
        isWorkoutActive = true  // Update the workout state to active
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
        isAudioPlaying = false
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

struct PrimaryButtonStyle: ButtonStyle {
    var isDisabled: Bool
    var backgroundColor: Color
    var textColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(isDisabled ? backgroundColor : textColor)
            .padding()
            .background(backgroundColor)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
