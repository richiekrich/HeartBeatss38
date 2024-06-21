//
//  FirestoreService.swift
//  HeartBeats38
//
//  Created by Richard Rich on 6/19/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class FirestoreService {
    private let db = Firestore.firestore()
    private let collection = "workouts"

    func fetchWorkouts() -> AnyPublisher<[Workout], Error> {
        Future<[Workout], Error> { promise in
            self.db.collection(self.collection).getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    let workouts = snapshot?.documents.compactMap { document in
                        try? document.data(as: Workout.self)
                    } ?? []
                    promise(.success(workouts))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func addWorkout(_ workout: Workout) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            do {
                _ = try self.db.collection(self.collection).addDocument(from: workout) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func deleteWorkout(_ workout: Workout) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            guard let workoutID = workout.id else {
                promise(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid workout ID."])))
                return
            }

            self.db.collection(self.collection).document(workoutID).delete { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateWorkout(_ workout: Workout) -> AnyPublisher<Void, Error> {
        guard let id = workout.id else {
            return Fail(error: NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Workout ID is missing."]))
                .eraseToAnyPublisher()
        }

        return Future { promise in
            self.db.collection(self.collection).document(id).setData(workout.dictionary) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
