import SwiftUI

struct SavedWorkouts: View {
    @ObservedObject var viewModel = WorkoutsViewModel()
    @State private var showingAddWorkout = false
    @State private var workoutToEdit: Workout?

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.workouts) { workout in
                    VStack(alignment: .leading) {
                        Text(workout.name)
                            .font(.headline)
                        Text(workout.duration)
                            .font(.subheadline)
                        Text("\(workout.date, formatter: Self.dateFormatter)")
                            .font(.caption)
                        Text("Avg Heartbeat: \(workout.avgHeartBeat) bpm")
                            .font(.caption)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteWorkout(workout)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            workoutToEdit = workout
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                }
            }
            .navigationBarTitle("Saved Workouts")
            .navigationBarItems(
                trailing: Button(action: {
                    showingAddWorkout.toggle()
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView(viewModel: viewModel)
            }
            .sheet(item: $workoutToEdit) { workout in
                EditWorkoutView(viewModel: viewModel, workout: workout)
            }
            .onAppear {
                viewModel.loadWorkouts()
            }
        }
    }

    private func deleteWorkout(_ workout: Workout) {
        viewModel.deleteWorkout(workout) { result in
            switch result {
            case .success:
                // Remove the workout locally if deletion is successful
                if let index = viewModel.workouts.firstIndex(where: { $0.id == workout.id }) {
                    viewModel.workouts.remove(at: index)
                }
            case .failure(let error):
                print("Error deleting workout: \(error.localizedDescription)")
            }
        }
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}
