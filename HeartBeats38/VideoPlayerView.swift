//
//  VideoPlayerView.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz on 4/18/24.
//

import SwiftUI
import AVFoundation

struct VideoPlayerView: UIViewControllerRepresentable {
    @EnvironmentObject var playerViewModel: PlayerViewModel
    var videoFileName: String
    var videoFileType: String

    func makeUIViewController(context: Context) -> VideoSplashViewController {
        let controller = VideoSplashViewController()
        controller.setupVideoPlayer(with: videoFileName, fileType: videoFileType)
        controller.completionHandler = {
            DispatchQueue.main.async {
                self.playerViewModel.videoCompleted = true
            }
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: VideoSplashViewController, context: Context) {
        // No update needed
    }
}
