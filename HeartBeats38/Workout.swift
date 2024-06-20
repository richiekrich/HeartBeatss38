//
//  Workout.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz on 4/18/24.
//

import Foundation
import FirebaseFirestoreSwift

struct Workout: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var duration: String
    var date: Date
    var avgHeartBeat: Int
}
