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

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Text("Heart Rate: \(viewModel.heartRate, specifier: "%.1f") BPM").foregroundColor(.white)
                Text(statusMessage)
                    .foregroundColor(.white)
                    .padding()
                
                if showCountdown {
                    Text("Workout starting in... \(countdown)")
                        .foregroundColor(.white)
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
                
                if isWorkoutActive{
                    Button(action: stopWorkout) {
                        Image("heartStop")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                }
                
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
    
  
    func startWorkout() {
        showCountdown = true
        countdown = 3
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
            }
        }
    }
    func stopWorkout() {
          viewModel.stopHeartRateSimulation()
          statusMessage = "Workout stopped."
          audioPlayerManager.stop()
          isWorkoutActive = false
          isAudioPlaying = false
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

