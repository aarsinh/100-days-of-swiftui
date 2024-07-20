//
//  SharingObservable.swift
//  SnowSeeker
//
//  Created by Aarav Sinha on 20/07/24.
//

import SwiftUI

@Observable
class Player {
    var name = "Anonymous"
    var highScore = 0
}

struct HighScoreView: View {
    @Environment(Player.self) var player
    var body: some View {
        @Bindable var player = player
        Stepper("High score: \(player.highScore)", value: $player.highScore)
    }
}

struct SharingObservable: View {
    @State var player = Player()
    var body: some View {
        VStack {
            Text("Welcome")
            HighScoreView()
        }
        .environment(player)
    }
}

#Preview {
    SharingObservable()
}
