//
//  Prospect.swift
//  Hot Propsects
//
//  Created by Aarav Sinha on 09/07/24.
//

import Foundation
import SwiftData

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    var dateAdded = Date.now
    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
    }
    
    #if DEBUG
    static let example = Prospect(name: "example", emailAddress: "example@example.com", isContacted: false)
    #endif
}
