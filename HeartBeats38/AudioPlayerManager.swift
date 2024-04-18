import Foundation
import AVFoundation

class AudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool = false

    override init() {
        super.init()
        loadAudioFile()
    }

    func loadAudioFile() {
        if let path = Bundle.main.path(forResource: "tyler dance VI_2", ofType: "mp3") {
            do {
                let url = URL(fileURLWithPath: path)
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.enableRate = true
                audioPlayer?.delegate = self  // Set delegate to self
            } catch {
                print("Failed to load audio file: \(error)")
            }
        } else {
            print("File not found")
        }
    }

    func play() {
        if !(audioPlayer?.isPlaying ?? true) {
            audioPlayer?.play()
            isPlaying = true
        }
    }

    func stop() {
        if audioPlayer?.isPlaying ?? false {
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0  // Rewind to the start for the next play
            isPlaying = false
        }
    }

    func adjustPlaybackRate(basedOnHeartRate heartRate: Double) {
        let baseHeartRate = 60.0
        let playbackRate = heartRate / baseHeartRate
        audioPlayer?.rate = Float(max(0.5, min(playbackRate, 2.0)))
    }

    // AVAudioPlayerDelegate method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}

