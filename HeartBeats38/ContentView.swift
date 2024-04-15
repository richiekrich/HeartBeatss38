import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var viewModel = HeartRateViewModel()
    @StateObject private var audioPlayerManager = AudioPlayerManager(audioFileName: "Heart", fileType: "mp3")  // Correctly initialized
    @State private var statusMessage = ""

    var body: some View {
        VStack {
            Text("Heart Rate: \(viewModel.heartRate, specifier: "%.1f") BPM")
            Text(statusMessage)
                .foregroundColor(.gray)
                .padding()

            Button("Start Workout") {
                viewModel.startHeartRateSimulation()
                statusMessage = "Workout started."
                audioPlayerManager.play()  // Start playing when workout starts
            }
            .disabled(viewModel.isWorkoutActive)
            .buttonStyle(PrimaryButtonStyle(isDisabled: viewModel.isWorkoutActive))

            Button("Stop Workout") {
                viewModel.stopHeartRateSimulation()
                statusMessage = "Workout stopped."
                audioPlayerManager.stop()  // Stop playing when workout stops
            }
            .disabled(!viewModel.isWorkoutActive)
            .buttonStyle(PrimaryButtonStyle(isDisabled: !viewModel.isWorkoutActive))

            Button("Play") {
                audioPlayerManager.play()
                statusMessage = "Playing audio."
            }
            .disabled(audioPlayerManager.isPlaying)
            .buttonStyle(PrimaryButtonStyle(isDisabled: audioPlayerManager.isPlaying))

            Button("Stop") {
                audioPlayerManager.stop()
                statusMessage = "Audio stopped."
            }
            .disabled(!audioPlayerManager.isPlaying)
            .buttonStyle(PrimaryButtonStyle(isDisabled: !audioPlayerManager.isPlaying))
        }
        .onChange(of: viewModel.heartRate) { newRate in
            audioPlayerManager.adjustPlaybackRate(basedOnHeartRate: newRate)
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var isDisabled: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(isDisabled ? .gray : .blue)
            .padding()
            .background(isDisabled ? Color.secondary : Color.blue)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
