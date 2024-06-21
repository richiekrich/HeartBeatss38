//
//  AudioFileManager.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz on 4/18/24.
//

import FirebaseStorage
import Combine
import SwiftUI

class AudioFileManager: ObservableObject {
    @Published var audioFiles: [String] = []

    func fetchAudioFiles() {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("Songs")

        storageRef.listAll { (result, error) in
            if let error = error {
                print("Error fetching audio files: \(error)")
                return
            }

            // Optional chaining to safely access items only if result is non-nil
            result?.items.forEach { item in
                let fileName = item.name
                DispatchQueue.main.async {
                    self.audioFiles.append(fileName)
                }
            }
        }
    }
}
