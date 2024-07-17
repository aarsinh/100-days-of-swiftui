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
    @State private var rollingDice = false
    
    @State private var showingSheet = false
    @State private var time: Double = 0
    var body: some View {
        NavigationStack {
            ZStack {
                Color.oxfordBlue
                    .ignoresSafeArea()
                VStack {
                    PickerView(diceSides: $diceSides, diceNumber: $diceNumber)
                    
                    if currentResult.isEmpty {
                        ContentUnavailableView("Roll the Dice", systemImage: "dice")
                            .padding(.top, 30)
                            .foregroundStyle(.white)
                            .frame(width: 400, height: 90)
                    } else {
                        HStack(spacing: 40) {
                            ForEach(currentResult, id: \.self) { result in
                                Text("\(result)")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 400, height: 90)
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
                            .disabled(rollingDice)
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
            .confirmationDialog("Delete history?", isPresented: $showingSheet, titleVisibility: .visible) {
                Button("Clear", role: .destructive, action: clear)
            }
            .toolbar {
                Button("Clear") {
                    showingSheet = true
                }
                .foregroundStyle(history.isEmpty ? .white.opacity(0.7) : .red)
                .disabled(history.isEmpty)
            }
        }
        
    }
    
    func clear() {
        history = []
        currentResult = []
        DataManager.save(history)
    }
    

        
    func rollDice() {
        rollHaptics()
        rollingDice = true
        currentResult = Array(repeating: 0, count: diceNumber)
        var iterations = 0
        let maxIterations = 10
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if iterations < maxIterations {
                for i in 0..<diceNumber {
                    currentResult[i] = Int.random(in: 1...diceSides)
                }
                iterations += 1
                time += 0.1
            } else {
                timer.invalidate()
                completeRoll()
                rollingDice = false
            }
        }
        
        time = 0
    }
        
    func completeRoll() {
        let total = currentResult.reduce(0, +)
        let newRoll = Roll(sides: diceSides, number: diceNumber, result: currentResult, total: total)
        history.insert(newRoll, at: 0)
        DataManager.save(history)
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
        
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: time)
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
