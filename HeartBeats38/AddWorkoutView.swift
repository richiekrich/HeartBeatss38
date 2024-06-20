//
//  AddWorkoutView.swift
//  HeartBeats38
//
//  Created by Richard Rich on 6/19/24.
//

import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutsViewModel
    @State private var name = ""
    @State private var duration = ""
    @State private var date = Date()
    @State private var avgHeartBeat = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Workout Details")) {
                    TextField("Name", text: $name)
                    TextField("Duration", text: $duration)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Avg Heartbeat", text: $avgHeartBeat)
                        .keyboardType(.numberPad)
                }
                
                Button(action: saveWorkout) {
                    Text("Save Workout")
                }
            }
            .navigationBarTitle("New Workout", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    func saveWorkout() {
        guard let avgHeartBeat = Int(avgHeartBeat) else { return }
        
        let newWorkout = Workout(name: name, duration: duration, date: date, avgHeartBeat: avgHeartBeat)
        viewModel.addWorkout(newWorkout)
        presentationMode.wrappedValue.dismiss()
    }
}
