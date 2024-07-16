//
//  DataManager.swift
//  DiceRolls
//
//  Created by Aarav Sinha on 15/07/24.
//

import Foundation

struct DataManager {
    static let savePath = URL.documentsDirectory.appending(path: "DiceRolls")
    
    static func load() -> [Roll] {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Roll].self, from: data) {
                return decoded
            }
        }
        return []
    }
    
    static func save(_ data: [Roll]) {
        if let encoded = try? JSONEncoder().encode(data) {
            try? encoded.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
    }
}
