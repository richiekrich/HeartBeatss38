//
//  AudioPlayerView.swift
//  HeartBeats38
//
//  Created by Richard Rich on 6/19/24.
//

import SwiftUI
import AVFoundation

struct AudioPlayerView: View {
    @ObservedObject var audioPlayerManager: AudioPlayerManager

    var body: some View {
        VStack {
            Text("Now Playing: \(audioPlayerManager.currentFileName ?? "None")")
            if let player = audioPlayerManager.audioPlayer {
                if player.isPlaying {
                    Button("Pause") {
                        audioPlayerManager.pause()
                    }
                } else {
                    Button("Play") {
                        audioPlayerManager.play()
                    }
                }
            }
        }
    }
}
