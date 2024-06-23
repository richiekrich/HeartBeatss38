//
//  FireStoreServiceProtocol.swift
//  HeartBeats38
//
//  Created by Richard Rich on 6/22/24.
//

import Combine

protocol FirestoreServiceProtocol {
    func fetchWorkouts() -> AnyPublisher<[Workout], Error>
    func addWorkout(_ workout: Workout) -> AnyPublisher<Void, Error>
    func deleteWorkout(_ workout: Workout) -> AnyPublisher<Void, Error>
    func updateWorkout(_ workout: Workout) -> AnyPublisher<Void, Error>
}
