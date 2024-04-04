import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HeartRateViewModel()

    var body: some View {
        Text("Heart Rate: \(viewModel.heartRate) BPM")
    }
}
