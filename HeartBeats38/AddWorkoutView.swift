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
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSaving = false

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
                    if isSaving {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Save Workout")
                    }
                }
                .disabled(isSaving)
            }
            .navigationBarTitle("New Workout", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func saveWorkout() {
        guard !name.isEmpty, !duration.isEmpty, !avgHeartBeat.isEmpty, let avgHeartBeatInt = Int(avgHeartBeat) else {
            alertMessage = "Please fill in all fields with valid data."
            showAlert = true
            return
        }
        
        print("Saving workout: \(name), \(duration), \(date), \(avgHeartBeatInt)")
        
        let newWorkout = Workout(name: name, duration: duration, date: date, avgHeartBeat: avgHeartBeatInt)
        isSaving = true
        
        viewModel.addWorkout(newWorkout) { result in
            isSaving = false
            switch result {
            case .success:
                alertMessage = "Workout saved successfully!"
                showAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    presentationMode.wrappedValue.dismiss()
                }
            case .failure(let error):
                alertMessage = "Failed to save workout: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}
