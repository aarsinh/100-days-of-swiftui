//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Aarav Sinha on 05/07/24.
//

import Foundation
import MapKit
import Observation
import CoreLocation
import LocalAuthentication

extension ContentView {
    @Observable
    class ViewModel {
        var selectedPlace: Location?
        private(set) var locations: [Location]
        var isUnlocked = false
        var mapStyle = true
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", latitude: point.latitude, longitude: point.longitude, description: "")
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
            }
            
            save()
        }
        
//        func deleteLocation(id: UUID) {
//            locations.removeAll { $0.id == id }
//            save()
//        }
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print(error)
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Authenticate to unlock places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        
                    }
                }
                
            } else {
                
            }
        }
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
                print(error)
            }
        }
    }
}
