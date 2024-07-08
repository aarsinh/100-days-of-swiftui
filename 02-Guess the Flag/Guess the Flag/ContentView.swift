//
//  ContentView.swift
//  Guess the Flag
//
//  Created by Aarav Sinha on 27/05/24.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    var rotateAmount: Double
    var opacityAmount: Double
    
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
            .rotation3DEffect(
                .degrees(Double(rotateAmount)), axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
            )
            .opacity(opacityAmount)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreText = ""
    @State private var animationAmount = 0.0
    @State private var buttonTapped = -1
    @State private var opacityAmount = 1.0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .teal, location: 0.35),
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.35)],
                           center: .top,
                           startRadius: 200,
                           endRadius: 700
            )
            .ignoresSafeArea()
            VStack(spacing: 30) {
                Text("Score: \(score)")
                    .padding(.bottom, 100)
                    .padding(.leading, 250)
                    .bold()
                    .foregroundStyle(Color(red: 0, green: 0, blue: 0.459))
                VStack {
                    Text("Guess the Flag")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(Color(red: 0, green: 0, blue: 0.459))
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.black)
                            .font(.headline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    VStack(spacing:30) {
                        ForEach(0..<3) { number in
                            Button {
                                flagTapped(number)
                                withAnimation {
                                    animationAmount += 360
                                }
                                
                                withAnimation {
                                    opacityAmount -= 0.75
                                }
                            } label: {
                                FlagImage(country: countries[number],
                                          rotateAmount: (number == buttonTapped ? animationAmount : -animationAmount),
                                          opacityAmount: (number == buttonTapped ? 1 : opacityAmount))
                                .accessibilityLabel(labels[countries[number]] ?? "Unknown Flag")
                            }
                        }
                    }
                }.padding(.bottom, 150)
            }
            .alert("\(scoreText)", isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(score)")
            }
        }
    }
    
    func flagTapped (_ number: Int) {
        buttonTapped = number
        if number == correctAnswer {
            scoreText = "Correct"
            withAnimation(.interactiveSpring) {
                score += 1
            }
        }
        
        else {
            scoreText = "Wrong"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        buttonTapped = -1
        animationAmount = 0
        opacityAmount = 1.0
    }
        
}

#Preview {
    ContentView()
}
