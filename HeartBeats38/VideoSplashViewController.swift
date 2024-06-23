import AVFoundation
import UIKit

class VideoSplashViewController: UIViewController {
    var player: AVPlayer?
    var completionHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupVideoPlayer(with fileName: String, fileType: String) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: fileType) else {
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

    @objc func videoDidEnd(notification: Notification) {
        player?.seek(to: .zero)
        player?.play()
        completionHandler?()
    }
}
