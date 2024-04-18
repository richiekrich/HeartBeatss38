//
//  AudioFilesView.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz on 4/18/24.
//

import SwiftUI

struct AudioFilesView: View {
    @ObservedObject var audioManager = AudioFileManager()
    @State private var showingFilePicker = false

    var body: some View {
        NavigationView {
            List {
                ForEach(audioManager.files, id: \.self) { file in
                    Text(file)
                }
                .onDelete(perform: audioManager.deleteFile)
            }
            .navigationBarTitle("My Tracks")
            .navigationBarItems(trailing: Button(action: {
                showingFilePicker = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingFilePicker) {
                DocumentPicker() { url in
                    audioManager.addFile(url: url)
                }
            }
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    var onPick: (URL) -> Void

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.audio"], in: .import)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            parent.onPick(url)
        }
    }
}

