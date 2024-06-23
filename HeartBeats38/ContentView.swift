import SwiftUI

struct ContentView: View {
    @ObservedObject var audioPlayerManager: AudioPlayerManager
    @StateObject private var heartRateViewModel = HeartRateViewModel()
    @StateObject private var workoutsViewModel = WorkoutsViewModel(firestoreService: FirestoreService())
    @State private var statusMessage = ""
    @State private var isWorkoutActive = false
    @State private var isAudioPlaying = false
    @State private var countdown = 3
    @State private var showCountdown = false
    @State private var buttonOpacity = 1.0
    @State private var elapsedTime = 0
    @State private var elapsedTimeTimer: Timer?
    @StateObject private var playerViewModel = PlayerViewModel()
    @State private var showSaveButton = false
    @State private var showAlert = false

    var body: some View {
        ZStack {
            if isWorkoutActive {
                VideoPlayerView(videoFileName: "heartbeats", videoFileType: "mp4")
                    .ignoresSafeArea()
                    .environmentObject(playerViewModel)
            } else {
                VideoPlayerView(videoFileName: "heartsplash", videoFileType: "mp4")
                    .ignoresSafeArea()
                    .environmentObject(playerViewModel)
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

                Text("Elapsed Workout Time: \(elapsedTime) seconds")
                    .foregroundColor(.black)
                    .padding()

                Text("Heart Rate: \(heartRateViewModel.heartRate, specifier: "%.1f") BPM")
                    .foregroundColor(.black)

                Text("Playback Rate: \(audioPlayerManager.audioPlayer?.rate ?? 1.0, specifier: "%.2f")x")
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

                    if showSaveButton {
                        Button(action: saveWorkout) {
                            Text("Save Workout")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .padding()
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Workout Saved!"), message: Text("Your workout has been saved successfully."), dismissButton: .default(Text("OK")))
                        }
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
                        .buttonStyle(PrimaryButtonStyle(isDisabled: !heartRateViewModel.isWorkoutActive, backgroundColor: .green, textColor: .white))
                }
            }
        }
        .onChange(of: heartRateViewModel.heartRate) { oldRate, newRate in
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
                heartRateViewModel.startHeartRateSimulation()
                statusMessage = "Workout started."
                if let audioPlayer = audioPlayerManager.audioPlayer, audioPlayer.url != nil {
                    audioPlayerManager.play()
                    isAudioPlaying = true
                }
                isWorkoutActive = true
                startElapsedTimeTimer()
                playerViewModel.videoCompleted = false // Reset video state
            }
        }
    }

    func restartWorkout() {
        stopWorkout()
        stopElapsedTimeTimer()
        elapsedTime = 0
        statusMessage = "Workout restarted."
        isWorkoutActive = false
        isAudioPlaying = false
        startWorkout()
    }

    func resumeWorkout() {
        heartRateViewModel.startHeartRateSimulation()
        startElapsedTimeTimer()
        statusMessage = "Workout resumed."
        isWorkoutActive = true
    }

    func pauseWorkout() {
        heartRateViewModel.pauseWorkout()
        statusMessage = "Workout paused."
        stopElapsedTimeTimer()
    }

    func stopWorkout() {
        heartRateViewModel.stopHeartRateSimulation()
        statusMessage = "Workout stopped."
        audioPlayerManager.stop()
        isWorkoutActive = false
        isAudioPlaying = false
        stopElapsedTimeTimer()
        showSaveButton = true
    }

    func saveWorkout() {
        let avgHeartRate = heartRateViewModel.calculateAverageHeartRate()
        let workout = Workout(
            name: "Workout \(Date())",
            duration: "\(elapsedTime) seconds",
            date: Date(),
            avgHeartBeat: Int(avgHeartRate)
        )
        
        workoutsViewModel.addWorkout(workout) { result in
            switch result {
            case .success:
                print("Workout saved successfully!")
                showSaveButton = false
                showAlert = true
            case .failure(let error):
                print("Failed to save workout: \(error.localizedDescription)")
            }
        }
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
