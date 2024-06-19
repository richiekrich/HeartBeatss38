import Foundation
import AVFoundation

class AudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool = false
    
    override init() {
        super.init()
    }
    
    func loadAudioFile(fileName: String) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.enableRate = true
            audioPlayer?.delegate = self
            print("Audio file loaded: \(fileName)")
        } catch {
            print("Failed to load audio file: \(error)")
        }
    }
    
    func play() {
        if let player = audioPlayer, !player.isPlaying {
            player.play()
            isPlaying = true
        }
    }
    
    func stop() {
        if let player = audioPlayer, player.isPlaying {
            player.stop()
            player.currentTime = 0
            isPlaying = false
        }
    }

    func adjustPlaybackRate(basedOnHeartRate heartRate: Double) {
        let baseHeartRate = 60.0
        let playbackRate = heartRate / baseHeartRate
        audioPlayer?.rate = Float(max(0.5, min(playbackRate, 2.0)))
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
