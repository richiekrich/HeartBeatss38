//
//  Workout.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz on 4/18/24.
//

import Foundation

struct Workout: Identifiable {
    var id = UUID()
    var name: String
    var duration: String
    var date: Date
    var avgHeartBeat: Int
}
