//
//  FirestoreService.swift
//  HeartBeats38
//
//  Created by Richard Rich on 6/19/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreService {
    private let db = Firestore.firestore()
    private let collection = "workouts"
    
    func fetchWorkouts(completion: @escaping (Result<[Workout], Error>) -> Void) {
        db.collection(collection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let workouts = documents.compactMap { (document) -> Workout? in
                try? document.data(as: Workout.self)
            }
            completion(.success(workouts))
        }
    }
    
    func addWorkout(_ workout: Workout, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            _ = try db.collection(collection).addDocument(from: workout) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
