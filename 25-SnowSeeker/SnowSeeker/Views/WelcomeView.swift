//
//  WelcomeView.swift
//  SnowSeeker
//
//  Created by Aarav Sinha on 20/07/24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker!")
                .font(.title)
            Text("Please select a resort from the left-hand menu; swipe from the left to open it.")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    WelcomeView()
}
