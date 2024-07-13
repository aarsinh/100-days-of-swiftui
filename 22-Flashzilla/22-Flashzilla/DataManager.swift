//
//  DataManager.swift
//  22-Flashzilla
//
//  Created by Aarav Sinha on 13/07/24.
//

import Foundation

struct DataManager {
    static let savePath = URL.documentsDirectory.appending(path: "SaveCards")
    
    static func load() -> [Card] {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                return decoded
            }
        }
        return []
    }
    
    static func save(_ cards: [Card]) {
        if let encoded = try? JSONEncoder().encode(cards) {
            try? encoded.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
    }
}
