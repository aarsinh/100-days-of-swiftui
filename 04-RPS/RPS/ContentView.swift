//
//  ContentView.swift
//  RPS
//
//  Created by Aarav Sinha on 30/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var choices = ["🪨", "📄", "✂️"]
    @State private var winningChoices = [1, 2, 0]
    @State private var currentChoice = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var scoreText = ""
    @State private var score = 0
    @State private var showingScore = false
    @State private var gameIsOver = false
    @State private var currentRound = 1
    private let numberOfGames = 10
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.red, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Text("Current Round: \(currentRound)")
                    .padding(.leading, 200)
                    .padding(.top, 30)
                    .bold()
                    .foregroundStyle(.white)
                Spacer()
                Text(choices[currentChoice])
                    .font(.system(size:100))
                
                HStack{
                    Text("How do you")
                        .foregroundStyle(.white)
                    Text("\(shouldWin ? "win" : "lose")")
                        .foregroundStyle(shouldWin ? .green : .red)
                    Text("this game?")
                        .foregroundStyle(.white)
                }.font(.system(size: 20))
                
                HStack {
                    ForEach(0..<3) { number in
                        Button("\(choices[number])")
                        {
                            checkAnswer(number)
                        }
                        .font(.system(size: 30))
                        .padding(10)
                    }
                    
                }
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.system(size: 30))
                Spacer()
            }
            .padding(.bottom, 50)
            .alert("\(scoreText)", isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            }
            
        }
        .alert("Game is over", isPresented: $gameIsOver) {
            Button("Restart Game") {
                restartGame()
            }
        }
    }
    
    func checkAnswer(_ number: Int) {
        var playerWin = false
        if shouldWin {
            playerWin = number == winningChoices[currentChoice]
        }
        else {
            playerWin = currentChoice == winningChoices[number]
        }
        
        scoreText = playerWin ? "Correct" : "Wrong"
        
        score = playerWin ? score + 1 : score - 1
        score = score < 0 ? 0 : score
        showingScore = true
        
    }
    
    func askQuestion() {
        if currentRound == numberOfGames{
            gameIsOver = true
        }
        else {
            currentRound += 1
            shouldWin = Bool.random()
            currentChoice = Int.random(in: 0...2)
        }
    }
    
    func restartGame() {
        shouldWin = Bool.random()
        currentChoice = Int.random(in: 0...2)
        currentRound = 1
        score = 0
    }
}


#Preview {
    ContentView()
}
