import SwiftUI

struct HomeView: View {
    @StateObject private var audioPlayerManager = AudioPlayerManager()

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    Image("hearthome")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .edgesIgnoringSafeArea(.all)
                }

                VStack {
                    Spacer()

                    NavigationLink(destination: ContentView(audioPlayerManager: audioPlayerManager)) {
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

                    NavigationLink(destination: AudioFilesView(audioPlayerManager: audioPlayerManager)) {
                        Text("My Tracks")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
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
