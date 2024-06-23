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
    @State private var countdownOffset: CGFloat = -500

    var body: some View {
        GeometryReader { geometry in
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
                    if showCountdown {
                        Text("\(countdown)")
                            .font(.system(size: 100, weight: .heavy, design: .rounded))
                            .foregroundColor(.black)
                            .offset(y: countdownOffset)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    countdownOffset = 0 // Move to center
                                }
                            }
                            .transition(.scale)
                            .padding(.top, 30)
                    } else {
                        // Elapsed Workout Time at the top
                        Text("Elapsed Workout Time: \(elapsedTime)s")
                            .font(.system(size: 50, weight: .heavy, design: .rounded))
                            .foregroundColor(.black)
                            .padding(.top, 30)

                        Spacer()

                        VStack {
                            if let currentFileName = audioPlayerManager.currentFileName {
                                Text("Now Playing: \(currentFileName)")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .padding()
                            } else {
                                Text("No Track Selected")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .padding()
                            }

                            Text("Heart Rate: \(heartRateViewModel.heartRate, specifier: "%.1f") BPM")
                                .font(.system(size: 16, weight: .medium, design: .default))
                                .foregroundColor(.black)
                        }
                        .padding(.bottom, 30) // Move text farther down but still above buttons

                        VStack {
                            HStack {
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
                                                .font(.system(size: 16, weight: .bold, design: .rounded))
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
                                    // Show "Resume Workout" button only if the workout is paused (isWorkoutActive is false)
                                    if !heartRateViewModel.isWorkoutActive {
                                        Button("Resume Workout", action: resumeWorkout)
                                            .buttonStyle(PrimaryButtonStyle(isDisabled: false, backgroundColor: .green, textColor: .white))
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 30) // Move buttons farther down
                    }
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
        countdownOffset = -500
        elapsedTime = 0
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 0 {
                withAnimation(.easeInOut(duration: 1.0)) {
                    countdownOffset = 250 // Move to center
                }
                countdown -= 1
            } else {
                withAnimation(.easeInOut(duration: 1.0)) {
                    countdownOffset = 500 // Drop out of view
                }
                timer.invalidate()
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
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
