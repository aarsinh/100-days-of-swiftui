//
//  ContentView.swift
//  22-Flashzilla
//
//  Created by Aarav Sinha on 10/07/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    
    @State private var isActive = true
    @State private var cardStack = DataManager.load()
    @State private var showingEditScreen = false
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Time remaining: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                
                ZStack {
                    ForEach(cardStack) { card in
                        let index = cardStack.firstIndex(of: card)!
                        CardView(card: card) { reinsert in
                            withAnimation {
                                removeItems(at: index, reinsert: reinsert)
                            }
                        }
                        .stacked(at: index, in: cardStack.count)
                        .allowsHitTesting(index == cardStack.count - 1)
                        .accessibilityHidden(index < cardStack.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                if cardStack.isEmpty {
                    Button("Reset cards", action: reset)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                        .padding(.top, 20)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }
                
                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                removeItems(at: cardStack.count - 1, reinsert: true)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeItems(at: cardStack.count - 1, reinsert: false)
                            }
                        } label : {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: reset, content: EditCards.init)
//        .onAppear(perform: reset)
        .onReceive(timer, perform: { _ in
            guard isActive else { return }
            
            if timeRemaining > 0 && cardStack.isNotEmpty {
                timeRemaining -= 1
            }
        })
        
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                if cardStack.isNotEmpty {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
            
    }
    
    func removeItems(at index: Int, reinsert: Bool) {
        guard index >= 0 else { return }
        
        if reinsert {
            cardStack.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
        } else {
            cardStack.remove(at: index)
        }
        if cardStack.isEmpty {
            isActive = false
        }
    }
    
    func reset() {
        isActive = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                timeRemaining = 100
            withAnimation {
                isActive = true
                cardStack = DataManager.load()
            }
        }
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

extension Collection {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

#Preview {
    ContentView()
}
