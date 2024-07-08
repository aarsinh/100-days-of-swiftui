//
//  Location.swift
//  EventContacts
//
//  Created by Aarav Sinha on 07/07/24.
//

import Foundation
import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    var onLocationUpdate: ((CLLocationCoordinate2D?) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
        if let onLocationUpdate = onLocationUpdate {
            onLocationUpdate(lastKnownLocation)
            manager.stopUpdatingLocation()
            self.onLocationUpdate = nil
        }
    }
}
