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
                    .offset(x: -20) // Adjust the x offset as needed to move the image to the left

                VStack {
                    Spacer()

                    NavigationLink(destination: ContentView(audioPlayerManager: audioPlayerManager)) {
                        Text("Start Workout")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white.opacity(0.3)) // More translucent white background
                            .cornerRadius(10)
                    }
                    .padding()

                    NavigationLink(destination: SavedWorkouts()) {
                        Text("My Workouts")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white.opacity(0.3)) // More translucent white background
                            .cornerRadius(10)
                    }
                    .padding()

                    NavigationLink(destination: AudioFilesView(audioPlayerManager: audioPlayerManager)) {
                        Text("My Tracks")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white.opacity(0.3)) // More translucent white background
                            .cornerRadius(10)
                    }
                    .padding()

                    Spacer()
                }
                .navigationBarTitle("Welcome to HeartBeats!", displayMode: .inline)
                .background(Color.clear) // Ensure VStack background is clear to show the image
            }
            .navigationBarHidden(true) // Hide navigation bar to prevent white space at top
        }
    }
}

#Preview {
    HomeView()
}
