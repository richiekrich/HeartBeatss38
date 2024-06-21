//
//  EditWorkoutView.swift
//  HeartBeats38
//
//  Created by Richard Rich on 6/20/24.
//

import SwiftUI

struct EditWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutsViewModel
    @State private var workout: Workout

    init(viewModel: WorkoutsViewModel, workout: Workout) {
        self.viewModel = viewModel
        _workout = State(initialValue: workout)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Workout Name", text: $workout.name)
                TextField("Duration", text: $workout.duration)
                TextField("Avg Heartbeat", value: $workout.avgHeartBeat, formatter: NumberFormatter())
                DatePicker("Date", selection: $workout.date, displayedComponents: .date)
            }
            .navigationBarTitle("Edit Workout", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                saveWorkout()
            })
        }
    }

    private func saveWorkout() {
        viewModel.updateWorkout(workout) { result in
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print("Error updating workout: \(error.localizedDescription)")
            }
        }
    }
}
