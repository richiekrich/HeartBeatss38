import SwiftUI

struct AudioFilesView: View {
    @ObservedObject var audioFileManager = AudioFileManager()
    @ObservedObject var audioPlayerManager: AudioPlayerManager
    @State private var selectedFile: String? = nil

    var body: some View {
        VStack {
            List(audioFileManager.files, id: \.self) { file in
                HStack {
                    Text(file)
                    Spacer()
                    Button(action: {
                        selectedFile = file
                    }) {
                        Text(selectedFile == file ? "Selected" : "Select")
                            .foregroundColor(selectedFile == file ? .green : .blue)
                    }
                }
            }
            .onAppear {
                print("AudioFilesView appeared, fetching files from Firebase")
                audioFileManager.fetchFilesFromFirebase()
            }

            if let selectedFile = selectedFile {
                NavigationLink(destination: WorkoutView(audioPlayerManager: audioPlayerManager, selectedFile: selectedFile)) {
                    Text("Proceed to Workout")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}

struct AudioFilesView_Previews: PreviewProvider {
    static var previews: some View {
        AudioFilesView(audioPlayerManager: AudioPlayerManager())
    }
}
