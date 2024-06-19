//
//  AudioFileManager.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz on 4/18/24.
//

import Foundation
import FirebaseStorage
import SwiftUI

class AudioFileManager: ObservableObject {
    @Published var files: [String] = []

    private let storage = Storage.storage()
    private let fileManager = FileManager.default
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    init() {
        fetchFilesFromFirebase()
    }

    func fetchFilesFromFirebase() {
        print("Fetching files from Firebase Storage")
        let storageRef = storage.reference().child("Songs")
        
        storageRef.listAll { [weak self] (result, error) in
            if let error = error {
                print("Error listing files: \(error)")
                return
            }
            
            guard let result = result else {
                print("No result found")
                return
            }
            
            for item in result.items {
                print("Found file: \(item.name)")
                self?.handleFile(item: item)
            }
        }
    }

    func handleFile(item: StorageReference) {
        let localURL = documentsPath.appendingPathComponent(item.name)
        print("Handling file: \(item.name) at local path: \(localURL.path)")
        if !fileManager.fileExists(atPath: localURL.path) {
            print("File does not exist locally, downloading: \(item.name)")
            item.write(toFile: localURL) { [weak self] url, error in
                if let error = error {
                    print("Error downloading file: \(error)")
                } else {
                    print("File downloaded successfully: \(item.name)")
                    DispatchQueue.main.async {
                        self?.loadFiles()
                    }
                }
            }
        } else {
            print("File already exists locally: \(item.name)")
            DispatchQueue.main.async {
                self.loadFiles()
            }
        }
    }

    func loadFiles() {
        print("Loading files from local directory")
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            files = fileURLs.filter { $0.pathExtension == "mp3" }.map { $0.lastPathComponent }
            print("Files loaded: \(files)")
        } catch {
            print("Error while enumerating files \(documentsPath.path): \(error.localizedDescription)")
        }
    }

    func deleteFile(at offsets: IndexSet) {
        for index in offsets {
            let fileName = files[index]
            let filePath = documentsPath.appendingPathComponent(fileName)
            do {
                try fileManager.removeItem(at: filePath)
                files.remove(at: index)
                print("File deleted locally: \(fileName)")
            } catch {
                print("Could not delete file locally: \(error)")
            }
        }
    }
}
