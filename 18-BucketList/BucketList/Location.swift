//
//  Location.swift
//  BucketList
//
//  Created by Aarav Sinha on 05/07/24.
//

import Foundation
import MapKit

struct Location: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var description: String
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
#if DEBUG
    static let example = Location(id: UUID(), name: "Null Island", latitude: 0, longitude: 0, description: "The island at 0 0 lat long")
#endif
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
