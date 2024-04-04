//
//  AudioPlayerManager.swift
//  HeartBeats38
//
//  Created by Richard Rich on 4/4/24.
//
import Foundation
import AVFoundation

class AudioPlayerManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?

    init(audioFileName: String, fileType: String) {
        if let path = Bundle.main.path(forResource: audioFileName, ofType: fileType) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.prepareToPlay()
            } catch {
                print("Audio file not found or couldn't be loaded")
            }
        }
    }

    func play() {
        if !(audioPlayer?.isPlaying ?? true) {
            audioPlayer?.play()
        }
    }

    func stop() {
        if audioPlayer?.isPlaying ?? false {
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0
        }
    }
}
