import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var viewModel = HeartRateViewModel()
    @StateObject private var audioPlayerManager = AudioPlayerManager(audioFileName: "Heart", fileType: "mp3")

    var body: some View {
        VStack {
            Text("Heart Rate: \(viewModel.heartRate, specifier: "%.1f") BPM")
            Button("Play") {
                audioPlayerManager.play()
            }
            Button("Stop") {
                audioPlayerManager.stop()
            }
        }
    }
}
