import AVFoundation
import SwiftUI
import Combine
import FirebaseStorage

class AudioPlayerManager: ObservableObject {
    @Published var audioPlayer: AVAudioPlayer?
    @Published var audioFiles: [String] = []
    @Published var currentFileName: String?

    init() {
        configureAudioSession()
        setupAudioInterruptionHandling()
    }

    func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }

    func setupAudioInterruptionHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }

    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let interruptionType = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }

        switch interruptionType {
        case .began:
            audioPlayer?.pause()
        case .ended:
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    audioPlayer?.play()
                }
            }
        default:
            break
        }
    }

    func fetchAudioFiles() {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("Songs")

        storageRef.listAll { (result, error) in
            if let error = error {
                print("Error fetching audio files: \(error)")
                return
            }

            result?.items.forEach { item in
                let fileName = item.name
                DispatchQueue.main.async {
                    self.audioFiles.append(fileName)
                }
            }
        }
    }

    func selectAudioFile(_ file: String) {
        currentFileName = file
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirectory.appendingPathComponent(file)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.enableRate = true
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error loading audio file: \(error)")
        }
    }

    func addAudioFile(url: URL) {
        let fileName = url.lastPathComponent
        DispatchQueue.main.async {
            self.audioFiles.append(fileName)
        }

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.copyItem(at: url, to: destinationURL)
        } catch {
            print("Error copying audio file: \(error)")
        }
    }

    func play() {
        audioPlayer?.play()
    }

    func pause() {
        audioPlayer?.pause()
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }

    func adjustPlaybackRate(basedOnHeartRate heartRate: Double) {
        let minBPM: Double = 60.0
        let maxBPM: Double = 180.0
        let minRate: Float = 0.5
        let maxRate: Float = 2.0

        let rate = minRate + (maxRate - minRate) * Float((heartRate - minBPM) / (maxBPM - minBPM))
        audioPlayer?.rate = rate
    }
}
