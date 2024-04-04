//  HeartRateManager.swift
//  HeartBeatsW Watch App
//
//  Created by Ernesto Diaz on 4/3/24.
//

import Foundation
import HealthKit
import WatchConnectivity

class HeartRateManager: NSObject {
    private let healthStore = HKHealthStore()
    private var heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)

    override init() {
        super.init()
        requestAuthorization()
    }

    private func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable(), let heartRateType = heartRateType else {
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: Set([heartRateType])) { success, _ in
            if success {
                self.startObservingHeartRate()
            }
        }
    }

    private func startObservingHeartRate() {
        guard let heartRateType = heartRateType else { return }

        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { query, completionHandler, _ in
            self.fetchLatestHeartRateSample { sample in
                guard let sample = sample else {
                    completionHandler()
                    return
                }
                
                let heartRateValue = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                // Instead of updating a label, send this data to the iPhone app
                self.sendHeartRateToiPhone(heartRateValue)
            }
            
            completionHandler()
        }
        
        healthStore.execute(query)
    }

    private func fetchLatestHeartRateSample(completion: @escaping (HKQuantitySample?) -> Void) {
        guard let sampleType = heartRateType else {
            completion(nil)
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            completion(samples?.first as? HKQuantitySample)
        }
        
        healthStore.execute(query)
    }

    private func sendHeartRateToiPhone(_ heartRate: Double) {
        // Use WatchConnectivity to send heart rate data to iPhone
        if WCSession.isSupported() {
            let session = WCSession.default
            session.sendMessage(["heartRate": heartRate], replyHandler: nil) { error in
                print("Error sending heart rate data: \(error.localizedDescription)")
            }
        }
    }
}
