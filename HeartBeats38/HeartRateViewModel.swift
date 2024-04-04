//
//  HeartRateViewModel.swift
//  HeartBeats
//
//  Created by Ernesto Diaz on 4/3/24.
//

import Foundation
import WatchConnectivity

class HeartRateViewModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var heartRate: Double = 0.0

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle session activation completion
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle session inactivity
        print("WCSession did become inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Reactivate the session
        session.activate()
        print("WCSession reactivated")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async { [weak self] in
            if let heartRate = message["heartRate"] as? Double {
                self?.heartRate = heartRate
            }
        }
    }
}
