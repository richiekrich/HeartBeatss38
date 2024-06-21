//
//  VideoSplashViewController.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz on 4/18/24.
//

import AVFoundation
import UIKit

class VideoSplashViewController: UIViewController {
    var player: AVPlayer?
    var completionHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
    }

    private func setupVideoPlayer() {
        guard let path = Bundle.main.path(forResource: "heartsplash", ofType: "mp4") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        player?.play()
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }

    @objc func videoDidEnd() {
        completionHandler?()
    }
}

