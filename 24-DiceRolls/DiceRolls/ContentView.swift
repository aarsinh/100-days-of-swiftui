//
//  ContentView.swift
//  DiceRolls
//
//  Created by Aarav Sinha on 14/07/24.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    @State private var engine: CHHapticEngine?
    
    @State private var diceNumber = 1
    @State private var diceSides = 6

    @State private var currentResult: [Int] = []
    @State private var history = DataManager.load()
    var body: some View {
        ZStack {
            Color.oxfordBlue
                .ignoresSafeArea()
            VStack {
                PickerView(diceSides: $diceSides, diceNumber: $diceNumber)

                if let latestRoll = history.first {
                    HStack(spacing: 40) {
                        ForEach(latestRoll.result, id: \.self) { result in
                            Text("\(result)")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 40)
                }
                
                ZStack {
                    VStack {
                        GeometryReader { proxy in
                            HistoryView(history: $history)
                                .frame(width: proxy.size.width, height: proxy.size.height)
                        }
                        
                        Button {
                            rollDice()
                        } label: {
                            Spacer()
                            HStack {
                                Text("⚃")
                                    .font(.largeTitle)
                                    .padding(.bottom, 4)
                                    .rotationEffect(Angle(degrees: 45))
                                Text("ROLL")
                                    .font(.title)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(.moonstone)
                        .clipShape(.rect(cornerRadius: 5))
                        .foregroundStyle(.primary)
                        .padding()
                        .onAppear(perform: prepareHaptics)
                    }
                }
                
            }
        }
        
    }
    
    func rollDice() {
        for _ in 0..<diceNumber {
            currentResult.append(Int.random(in: 1...diceSides))
        }
        
        let total = currentResult.reduce(0, +)
        let newRoll = Roll(sides: diceSides, number: diceNumber, result: currentResult, total: total)
        history.insert(newRoll, at: 0)
        DataManager.save(history)
        rollHaptics()
        currentResult = []
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("cannot prepare haptics: \(error)")
        }
    }
    
    func rollHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("haptics could not be run: \(error)")
        }
    }
    
}

#Preview {
    ContentView()
}
