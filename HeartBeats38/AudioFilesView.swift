import SwiftUI

struct AudioFilesView: View {
    @ObservedObject var audioPlayerManager: AudioPlayerManager
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedFile: String?
    @State private var showingDocumentPicker = false

    var body: some View {
        VStack {
            List(audioPlayerManager.audioFiles, id: \.self) { file in
                HStack {
                    Text(file)
                    Spacer()
                    if selectedFile == file {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedFile = file
                }
            }
            .navigationTitle("Audio Files")

            if let selectedFile = selectedFile {
                Button(action: {
                    audioPlayerManager.selectAudioFile(selectedFile)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Proceed to Workout")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding()
            }

            Button(action: {
                showingDocumentPicker = true
            }) {
                Text("Add Your Own Track")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .sheet(isPresented: $showingDocumentPicker) {
            DocumentPicker { url in
                audioPlayerManager.addAudioFile(url: url)
            }
        }
        .onAppear {
            audioPlayerManager.fetchAudioFiles()
        }
    }
}
