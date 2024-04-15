import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var viewModel = HeartRateViewModel()
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    @State private var statusMessage = ""
    @State private var isWorkoutActive = false
    @State private var isAudioPlaying = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Text("Heart Rate: \(viewModel.heartRate, specifier: "%.1f") BPM").foregroundColor(.white)
                Text(statusMessage)
                    .foregroundColor(.white)
                    .padding()
                
                Button("Start Workout") {
                    viewModel.startHeartRateSimulation()
                    statusMessage = "Workout started."
                    audioPlayerManager.play()
                    isWorkoutActive = true
                }
                .disabled(viewModel.isWorkoutActive)
                .buttonStyle(PrimaryButtonStyle(isDisabled: viewModel.isWorkoutActive, backgroundColor: .gray, textColor: isWorkoutActive ? .gray : .white))
                
                Button("Stop Workout") {
                    viewModel.stopHeartRateSimulation()
                    statusMessage = "Workout stopped."
                    audioPlayerManager.stop()
                    isWorkoutActive = false
                    isAudioPlaying = false
                }
                .disabled(!viewModel.isWorkoutActive)
                .buttonStyle(PrimaryButtonStyle(isDisabled: !viewModel.isWorkoutActive, backgroundColor: .red, textColor: !isWorkoutActive ? .red : .white))
                
                Button("Play") {
                    audioPlayerManager.play()
                    statusMessage = "Playing audio."
                    isAudioPlaying = true
                }
                .disabled(audioPlayerManager.isPlaying)
                .buttonStyle(PrimaryButtonStyle(isDisabled: viewModel.isWorkoutActive, backgroundColor: .gray, textColor: isAudioPlaying ? .gray : .white))
                
                Button("Stop") {
                    audioPlayerManager.stop()
                    statusMessage = "Audio stopped."
                    isAudioPlaying = false
                }
                .disabled(!audioPlayerManager.isPlaying)
                .buttonStyle(PrimaryButtonStyle(isDisabled: !isAudioPlaying, backgroundColor: .red, textColor: isAudioPlaying ? .white : .red))
                
                Button("Restart Workout") {
                    viewModel.restartWorkout()
                    statusMessage = "Workout restarted."
                    isWorkoutActive = false
                    isAudioPlaying = false
                }
                .buttonStyle(PrimaryButtonStyle(isDisabled: false, backgroundColor: .blue, textColor: .white))
            }
            .onChange(of: viewModel.heartRate){ newRate in
                audioPlayerManager.adjustPlaybackRate(basedOnHeartRate: newRate)
            }
        }
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
