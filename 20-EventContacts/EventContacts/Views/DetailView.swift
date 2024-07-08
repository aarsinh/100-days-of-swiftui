//
//  DetailView.swift
//  EventContacts
//
//  Created by Aarav Sinha on 06/07/24.
//

import SwiftUI
import CoreLocation

struct DetailView: View {
    var person: Person
    @State private var viewNumber = 0
    var body: some View {
        Picker("", selection: $viewNumber) {
            Text("Photo").tag(0)
            Text("Location").tag(1)
        }
        .pickerStyle(.segmented)
        .padding()

        
        if viewNumber == 0 {
                        person.image
                            .resizable()
                            .scaledToFill()
                            .navigationBarTitle(person.name, displayMode: .inline)
        } else {
            if person.locationSet {
                NavigationStack {
                    MapView(coordinates: getCoords(latitude: person.latitude, longitude: person.longitude))
                        .navigationBarTitle("Event Location", displayMode: .inline)
                    Spacer()
                }
            } else {
                ContentUnavailableView("No location added", systemImage: "mappin.slash", description: Text("Location could not be recorded"))
            }
        }
        
    }
    
    func getCoords(latitude: Double, longitude: Double) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

#Preview {
    DetailView(person: .example)
}
