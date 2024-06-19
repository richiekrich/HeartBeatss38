//
//  PrimaryButtonStyle.swift
//  HeartBeats38
//
//  Created by Richard Rich on 6/19/24.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var isDisabled: Bool
    var backgroundColor: Color
    var textColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(isDisabled ? backgroundColor : textColor)
            .padding()
            .background(backgroundColor)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
