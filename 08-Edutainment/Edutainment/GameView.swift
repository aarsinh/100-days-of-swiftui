//
//  GameView.swift
//  Edutainment
//
//  Created by Aarav Sinha on 09/06/24.
//

import SwiftUI

struct GameView: View {
    @Environment (\.dismiss) var dismiss
    @State var tablesUpto: Int
    @State var numberOfQs: Int
    
    @State private var score = 0
    @State private var questionNumber = 0
    @State private var questions = [Question]()
    @State private var gameOver = false
    @State private var answer = ""
    @State private var alertTitle = ""
    @State private var isShowing = false

    var body: some View {
        NavigationStack {
            VStack{
                VStack {
                    if questions.isNotEmpty {
                        Text(questions[questionNumber].text)
                            .font(.system(size: 30))
                        TextField("Answer", text: $answer)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .padding(.trailing, 10)
                            .padding(.bottom, 10)
                        
                        Button("Submit") {
                            checkAnswer(answer)
                            answer = ""
                        }
                        .padding(30)
                        .background(.red)
                        .foregroundStyle(.white)
                        .clipShape(.circle)
                        
                    }
                    
                }
                .alert(alertTitle, isPresented: $isShowing) {
                    
                }
                .alert("Game over", isPresented: $gameOver)
                {
                    Button("OK") {
                        dismiss()
                    }
                } message: {
                    Text("Your score is \(score)/\(numberOfQs)")
                }
                
                
                .font(.system(size: 20))
            }
            .onAppear(perform: generateQuestions)
            .navigationTitle("Multiplication")
            .toolbar {
                VStack {
                    Text("Score: \(score)")
                        .font(.system(size: 20))
                        .padding(.leading, 10)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    func checkAnswer(_ answer: String) {
        if questionNumber < numberOfQs - 1 {
            if answer == questions[questionNumber].result {
                score += 1
                alertTitle = "Correct!"
            }
            else {
                alertTitle = "Wrong"
            }
            isShowing = true
            questionNumber += 1

        }
        
        else {
            if answer == questions[numberOfQs - 1].result {
                score += 1
            }
            isShowing = true
            gameOver = true
        }
    }
    
    func generateQuestions() {
        questions = Questions(upto: tablesUpto, numberOfQs: numberOfQs).questions
        questionNumber = 0
    }
    
    struct Question {
        var text: String
        var result: String
    }
    
    struct Questions {
        var questions = [Question]()
        init(upto: Int, numberOfQs: Int) {
            questions = generateQuestion(upto: upto, numberOfQs: numberOfQs)
        }
        
        func generateQuestion(upto: Int, numberOfQs: Int) -> [Question] {
            var temp = [Question]()
            for i in 1...upto {
                for j in 1...10 {
                    let result = String(i * j)
                    temp.append(Question(text: "\(i) * \(j) = ", result: result))
                }
            }
            temp.shuffle()
            return Array(temp[0..<numberOfQs])
        }
    }
    

}


#Preview {
    GameView(tablesUpto: 10, numberOfQs: 10)
}
