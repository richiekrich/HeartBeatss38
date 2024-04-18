//
//  HomeView.swift
//  HeartBeats38
//
//  Created by Ernesto Diaz on 4/18/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isPulsing = false
    
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            NavigationView {
                VStack {
                    Image("hearthome")
                        .resizable() //
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                        .padding(.bottom, 10)
                        .opacity(isPulsing ? 1.0 : 0.3)  // Opacity changes from 0.3 to 1.0
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                isPulsing.toggle() // Start the animation when the view appears
                                                }
                                            }
                    
                    
                    NavigationLink(destination: ContentView()) {
                        Text("Start Workout")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()

                    NavigationLink(destination: SavedWorkouts()) {
                        Text("My Workouts")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    NavigationLink(destination: AudioFilesView()) {
                        Text("My Tracks")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .navigationBarTitle("Welcome to HeartBeats!", displayMode: .inline).background(Color.white)
            }
        }
        }
       
}


#Preview {
    HomeView()
}
