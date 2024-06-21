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
                            viewModel.deleteWorkout(workout) { result in
                                switch result {
                                case .success:
                                    print("Workout deleted successfully")
                                case .failure(let error):
                                    print("Error deleting workout: \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            workoutToEdit = workout
                        } label: {
                            Label("Edit", systemImage: "pencil")
                                .labelStyle(.iconOnly)
                                .foregroundColor(.blue)
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
            .sheet(item: $workoutToEdit) { workout in
                EditWorkoutView(viewModel: viewModel, workout: workout)
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadWorkouts()
            }
        }
    }

    func deleteWorkout(at offsets: IndexSet) {
        offsets.forEach { index in
            let workout = viewModel.workouts[index]
            viewModel.deleteWorkout(workout) { result in
                switch result {
                case .success:
                    print("Workout deleted successfully")
                case .failure(let error):
                    print("Error deleting workout: \(error.localizedDescription)")
                }
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
