//
//  ContentView.swift
//  WordScramble
//
//  Created by Aarav Sinha on 01/06/24.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @FocusState private var wordFieldFocused: Bool
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .focused($wordFieldFocused)
                        .autocorrectionDisabled()
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle.fill")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
        }
        .alert(errorTitle, isPresented: $showingError) {}
        message: {
            Text(errorMessage)
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word already used", message: "You cannot use the same word twice")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word is not real", message: "You cannot make up words")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You cannot spell that word from \(rootWord)")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        newWord = ""
        wordFieldFocused = true
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start" , withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let words = startWords.components(separatedBy: "\n")
                
                rootWord = words.randomElement() ?? "silkworm"
                
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var root = rootWord
        
        for letter in word {
            if let pos = root.firstIndex(of: letter) {
                root.remove(at: pos)
            }
            
            else {
                return false
            }
        }
        
        return true
        
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspellRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspellRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
