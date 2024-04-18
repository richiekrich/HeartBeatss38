//
//  AudioFileManager.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz on 4/18/24.
//

import Foundation

class AudioFileManager: ObservableObject {
    @Published var files: [String] = []

    init() {
        loadFiles()
    }

    
    func loadFiles() {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            self.files = fileURLs.filter{ $0.pathExtension == "mp3" }.map{ $0.lastPathComponent }
        } catch {
            print("Error while enumerating files \(documentsPath.path): \(error.localizedDescription)")
        }
    }

    func addFile(url: URL) {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        do {
            try fileManager.copyItem(at: url, to: destinationURL)
            self.loadFiles()
        } catch {
            print("Could not copy file: \(error)")
        }
    }

    func deleteFile(at index: IndexSet) {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

        index.forEach { idx in
            let filePath = documentsPath.appendingPathComponent(files[idx])
            do {
                try fileManager.removeItem(at: filePath)
                files.remove(at: idx)
            } catch {
                print("Could not delete file: \(error)")
            }
        }
    }
}
