import SwiftUI

struct HomeView: View {
    @StateObject private var audioPlayerManager = AudioPlayerManager()

    var body: some View {
        NavigationView {
            ZStack {
                Image("hearthome")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .offset(x: -25) // Adjust the x offset as needed to move the image to the left

                VStack {
                    Spacer()

                    // Add padding or spacer above the VStack to lower the buttons
                    Spacer()

                    NavigationLink(destination: ContentView(audioPlayerManager: audioPlayerManager)) {
                        Text("Start Workout")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.1)) // More translucent white background
                            .cornerRadius(10)
                    }
                    .padding()

                    NavigationLink(destination: SavedWorkouts()) {
                        Text("My Workouts")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.1)) // More translucent white background
                            .cornerRadius(10)
                    }
                    .padding()

                    NavigationLink(destination: AudioFilesView(audioPlayerManager: audioPlayerManager)) {
                        Text("My Tracks")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.1)) // More translucent white background
                            .cornerRadius(10)
                    }
                    .padding()

                    Spacer()
                }
                .navigationBarTitle("Welcome to HeartBeats!", displayMode: .inline)
                .background(Color.clear) // Ensure VStack background is clear to show the image
                .padding(.top, 400) // Adjust the top padding to lower the VStack
            }
            .navigationBarHidden(true) // Hide navigation bar to prevent white space at top
        }
    }
}
