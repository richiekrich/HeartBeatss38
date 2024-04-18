//
//  VideoPlayerView.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz on 4/18/24.
//

import SwiftUI
import UIKit

struct VideoPlayerView: UIViewControllerRepresentable {
    @EnvironmentObject var playerViewModel: PlayerViewModel

    func makeUIViewController(context: Context) -> VideoSplashViewController {
        let controller = VideoSplashViewController()
        controller.completionHandler = {
            DispatchQueue.main.async {
                self.playerViewModel.videoCompleted = true
            }
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: VideoSplashViewController, context: Context) {
    }
}
