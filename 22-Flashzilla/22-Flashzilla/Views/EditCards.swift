//
//  EditCards.swift
//  22-Flashzilla
//
//  Created by Aarav Sinha on 12/07/24.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) var dismiss
    @State private var cards = DataManager.load()
    @State private var newQuestion = ""
    @State private var newAnswer = ""
    @FocusState private var questionFocused: Bool
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Question", text: $newQuestion)
                        .focused($questionFocused)
                    TextField("Answer", text: $newAnswer)
                    Button("Add", action: addData)
                }
                
                Section {
                    ForEach(cards) { card in
                        VStack(alignment: .leading) {
                            Text(card.question)
                                .font(.headline)
                            Text(card.answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
        }
    }
    
    func done() {
        dismiss()
    }
    
    func saveData() {
        DataManager.save(cards)
    }
    
    func addData() {
        let trimmedQuestion = newQuestion.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedQuestion.isNotEmpty && trimmedAnswer.isNotEmpty else { return }
        
        let newCard = Card(question: trimmedQuestion, answer: trimmedAnswer)
        cards.insert(newCard, at: 0)
        newQuestion = ""
        newAnswer = ""
        
        questionFocused = true
        saveData()
    }
    
    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveData()
    }
}

extension String {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}

#Preview {
    EditCards()
}
