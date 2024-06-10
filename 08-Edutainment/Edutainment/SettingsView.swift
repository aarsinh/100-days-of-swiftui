//
//  ContentView.swift
//  Edutainment
//
//  Created by Aarav Sinha on 05/06/24.
//

import SwiftUI

extension Array {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

struct SettingsView: View {
    @State private var isGameActive = false
    @State private var tablesUpto = 1
    @State private var numberOfQuestions = 0
    let questionNumbers = [5, 10, 20]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Form {
                        Section(header:
                                    Text("Tables upto")
                            .font(.headline)
                            .foregroundStyle(.purple))
                        {
                            Stepper(value: $tablesUpto, in: 1...10) {
                                Text("\(tablesUpto)")
                            }
                            
                            
                        }
                        
                        Section(header:
                                    Text("Number of questions")
                            .font(.headline)
                            .foregroundStyle(.purple)) {
                                Picker("Number of questions", selection: $numberOfQuestions) {
                                    ForEach(questionNumbers, id: \.self) {
                                        Text("\($0)")
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            
                        
                    }
                }
                .scrollContentBackground(.hidden)
                NavigationLink("Start") {
                    GameView(tablesUpto: tablesUpto, numberOfQs: numberOfQuestions)
                }
                .disabled(numberOfQuestions == 0)
                .font(.title)
                .navigationBarTitle("Choose Settings")
                
            }
            
        }
        .preferredColorScheme(.dark)
        
    }
}

#Preview {
    SettingsView()
}
