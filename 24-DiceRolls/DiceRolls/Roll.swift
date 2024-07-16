//
//  Roll.swift
//  DiceRolls
//
//  Created by Aarav Sinha on 15/07/24.
//

import Foundation

struct Roll: Codable, Identifiable, Hashable {
    var id = UUID()
    var sides: Int
    var number: Int
    var result: [Int]
    var total: Int
    
    #if DEBUG
    static let example = Roll(sides: 6, number: 6, result: [1, 1, 1, 1], total: 4)
    #endif
}
