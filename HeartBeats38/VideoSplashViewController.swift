//
//  VideoSplashViewController.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz on 4/15/24.
//

import SwiftUI
import UIKit
import AVFoundation

class VideoSplashViewController: UIViewController {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
    }

    private func setupVideoPlayer() {
        guard let path = Bundle.main.path(forResource: "videoSplash", ofType:"mp4") else {
            debugPrint("Video file not found")
            return
        }
        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        player?.isMuted = true // Usually, splash videos are muted.

        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.view.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let layer = playerLayer {
            self.view.layer.addSublayer(layer)
        }

        player?.play()

        // Observe when the video ends to transition to the main interface
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(videoDidEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }

    @objc func videoDidEnd() {
        transitionToMainInterface()
    }

    private func transitionToMainInterface() {
        // Transition to your ContentView or main interface
        // Here we simply dismiss the video controller
        DispatchQueue.main.async {
            if let window = self.view.window {
                let mainViewController = MainViewController() // Your main view controller
                window.rootViewController = mainViewController
            }
        }
    }
}
