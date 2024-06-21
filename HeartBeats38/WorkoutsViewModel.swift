import SwiftUI
import Combine

class WorkoutsViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var firestoreService = FirestoreService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadWorkouts()
    }

    func loadWorkouts() {
        isLoading = true
        firestoreService.fetchWorkouts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Error fetching workouts: \(error.localizedDescription)"
                    print(self.errorMessage ?? "")
                }
            }, receiveValue: { [weak self] workouts in
                self?.workouts = workouts
            })
            .store(in: &cancellables)
    }

    func addWorkout(_ workout: Workout, completion: @escaping (Result<Void, Error>) -> Void) {
        guard validateWorkout(workout) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid workout data."])))
            return
        }

        isLoading = true
        firestoreService.addWorkout(workout)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionState in
                self.isLoading = false
                switch completionState {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    completion(.success(()))
                    self.workouts.append(workout)
                }
            }, receiveValue: { })
            .store(in: &cancellables)
    }

    func deleteWorkout(_ workout: Workout, completion: @escaping (Result<Void, Error>) -> Void) {
        isLoading = true
        firestoreService.deleteWorkout(workout)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionState in
                self.isLoading = false
                switch completionState {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    if let index = self.workouts.firstIndex(where: { $0.id == workout.id }) {
                        self.workouts.remove(at: index)
                    }
                    completion(.success(()))
                }
            }, receiveValue: { })
            .store(in: &cancellables)
    }

    func updateWorkout(_ workout: Workout, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = workout.id else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Workout ID is missing."])))
            return
        }

        isLoading = true
        firestoreService.updateWorkout(workout)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionState in
                self.isLoading = false
                switch completionState {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    if let index = self.workouts.firstIndex(where: { $0.id == id }) {
                        self.workouts[index] = workout
                    }
                    completion(.success(()))
                }
            }, receiveValue: { })
            .store(in: &cancellables)
    }

    private func validateWorkout(_ workout: Workout) -> Bool {
        return !workout.name.isEmpty && !workout.duration.isEmpty && workout.avgHeartBeat > 0
    }
}
