//
//  Card.swift
//  22-Flashzilla
//
//  Created by Aarav Sinha on 10/07/24.
//

import Foundation

struct Card: Codable, Identifiable, Equatable {
    var id = UUID()
    var question: String
    var answer: String
    
    #if DEBUG
    static let example = Card(question: "What is the capital of India?", answer: "New Delhi")
    #endif
    
}
