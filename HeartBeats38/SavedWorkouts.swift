//
//  SavedWorkouts.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz on 4/18/24.
//

import SwiftUI

struct SavedWorkouts: View {
    @ObservedObject var viewModel = WorkoutsViewModel()
    @State private var showingAddWorkout = false

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
                }
                .onDelete(perform: deleteWorkout)
            }
            .navigationBarTitle("Saved Workouts")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    showingAddWorkout.toggle()
                }) {
                    Image(systemName: "plus")
                }
            )
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
