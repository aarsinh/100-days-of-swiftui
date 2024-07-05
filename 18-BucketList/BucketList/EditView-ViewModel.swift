//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Aarav Sinha on 05/07/24.
//

import Foundation
import MapKit
import Observation

extension EditView {
    @Observable
    class ViewModel {
        var location: Location
        var name: String
        var description: String
        
        enum LoadingState {
            case loading, loaded, failed
        }
        
        var loadingState = LoadingState.loading
        var pages = [Page]()
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(Result.self, from: data)
                pages = decoded.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
                print(error)
            }
        }
        
        init(location: Location) {
            self.location = location
            self.name = location.name
            self.description = location.description
        }
    }
}
