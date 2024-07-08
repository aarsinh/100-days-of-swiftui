//
//  MapView.swift
//  EventContacts
//
//  Created by Aarav Sinha on 07/07/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    var coordinates: CLLocationCoordinate2D
    
    var body: some View {
        Map {
            Annotation("", coordinate: coordinates) {
                Image(systemName: "mappin")
                    .resizable()
                    .foregroundStyle(.red)
                    .frame(width: 10, height: 28)
            }
        }
    }
}

#Preview {
    MapView(coordinates: CLLocationCoordinate2D())
}
