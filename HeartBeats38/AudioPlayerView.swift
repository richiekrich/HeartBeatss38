//
//  AudioPlayerView.swift
//  HeartBeats38
//
//  Created by Richard Rich on 6/19/24.
//

import SwiftUI
import AVKit

struct AudioPlayerView: View {
    @ObservedObject var audioPlayerManager: AudioPlayerManager
    let fileName: String

    var body: some View {
        VStack {
            if audioPlayerManager.audioPlayer != nil {
                Text("Playing: \(fileName)")
                    .padding()

                // Placeholder for audio playback UI
                // Use AVPlayer or another UI element for actual playback
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 50)

                HStack {
                    Button(action: {
                        audioPlayerManager.play()
                    }) {
                        Image(systemName: "play.fill")
                    }
                    Button(action: {
                        audioPlayerManager.stop()
                    }) {
                        Image(systemName: "stop.fill")
                    }
                }
            } else {
                Text("Loading audio...")
                    .padding()
            }
        }
        .onAppear {
            audioPlayerManager.loadAudioFile(fileName: fileName)
        }
    }
}
