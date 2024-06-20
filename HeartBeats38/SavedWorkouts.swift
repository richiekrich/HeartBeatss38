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
            List(viewModel.workouts) { workout in
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
            .navigationBarTitle("Saved Workouts")
            .navigationBarItems(trailing: Button(action: {
                showingAddWorkout.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView(viewModel: viewModel)
            }
        }
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    struct SavedWorkouts_Previews: PreviewProvider {
        static var previews: some View {
            SavedWorkouts()
        }
    }
}
