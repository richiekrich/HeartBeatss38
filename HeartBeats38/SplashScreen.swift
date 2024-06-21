//
//  SplashScreen.swift
//  HeartBeats38
//
//  Created by Richard Rich on 6/21/24.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack {
            Text("Welcome to HeartBeats38")
                .font(.largeTitle)
                .fontWeight(.bold)
            ProgressView()
                .padding()
        }
        .padding()
    }
}
