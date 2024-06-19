import SwiftUI

struct HomeView: View {
    @State private var isPulsing = false
    @StateObject private var audioPlayerManager = AudioPlayerManager() // Create an instance of AudioPlayerManager

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            NavigationView {
                VStack {
                    Image("hearthome")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                        .padding(.bottom, 10)
                        .opacity(isPulsing ? 1.0 : 0.3)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                isPulsing.toggle()
                            }
                        }

                    NavigationLink(destination: ContentView(audioPlayerManager: audioPlayerManager)) { // Pass the instance
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

                    NavigationLink(destination: AudioFilesView(audioPlayerManager: audioPlayerManager)) { // Pass the instance
                        Text("My Tracks")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .navigationBarTitle("Welcome to HeartBeats!", displayMode: .inline)
                .background(Color.white)
            }
        }
    }
}

#Preview {
    HomeView()
}
