//
//  Person.swift
//  EventContacts
//
//  Created by Aarav Sinha on 06/07/24.
//

import Foundation
import SwiftUI

struct Person: Identifiable, Equatable, Codable, Comparable {
    
    var id = UUID()
    var name: String
    var photoData: Data
    
    var locationSet = false
    var latitude = 0.0
    var longitude = 0.0
    
    var image: Image {
        guard let uiImage = UIImage(data: photoData) else { return Image(systemName: "person.fill") }
        return Image(uiImage: uiImage)
    }
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
     
    #if DEBUG
    static let example = Person(name: "aa", photoData: Data())
    #endif
}
