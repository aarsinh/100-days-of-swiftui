//
//  ContentView.swift
//  BucketList
//
//  Created by Aarav Sinha on 29/06/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var viewModel = ViewModel()
    let startLocation = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 28.312, longitude: 18.039), span: MKCoordinateSpan(latitudeDelta: 70, longitudeDelta: 70))
    )
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                MapReader { proxy in
                    Map(initialPosition: startLocation) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "mappin ")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 10, height: 28)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                                
                            }
                        }
                    }
                    .mapStyle(viewModel.mapStyle ? .standard : .hybrid)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
                }
                
                Button {
                    viewModel.mapStyle.toggle()
                } label: {
                    Image(systemName: "map.fill")
                        .frame(width: 40, height: 40)
                        .background(.black)
                        .clipShape(.rect(cornerRadius: 5))
                }
                .buttonStyle(.plain)
                .position(x: 340, y: 52)
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 10))
                
        }
    }
}

#Preview {
    ContentView()
}
