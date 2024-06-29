//
//  Friend.swift
//  FriendFace
//
//  Created by Aarav Sinha on 26/06/24.
//

import Foundation
import SwiftData

class Friend: Codable, Identifiable {
    var id: UUID
    var name: String

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
