//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Aarav Sinha on 18/07/24.
//

import SwiftUI

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var favourites = Favourites()
    @State private var searchText = ""
    @State private var selectedResort: Resort?
    @State private var sortOrder = SortOrder.defaultOrder
    
    enum SortOrder: String, Identifiable, CaseIterable {
        case defaultOrder = "Default"
        case alphabetical = "Alphabetical"
        case country = "Country"
        
        var id: String { self.rawValue }
    }
    
    var sortedResorts: [Resort] {
        switch sortOrder {
        case .defaultOrder:
            return resorts
        case .alphabetical:
            return resorts.sorted { $0.name < $1.name }
        case .country:
            return resorts.sorted { $0.country < $1.country }
        }
    }
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            sortedResorts
        } else {
            sortedResorts.filter { $0.name.localizedStandardContains(searchText) || $0.country.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(filteredResorts, selection: $selectedResort) { resort in
                NavigationLink(value: resort) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(.rect(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundStyle(.secondary)
                        }
                        
                        if favourites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favourite resort")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .toolbar {
                Menu("Sort order", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        ForEach(SortOrder.allCases) { order in
                            Text("Sort by \(order.rawValue)")
                                .tag(order)
                        }
                    }
                }
            }
            .navigationDestination(for: Resort.self) { resort in
                ResortView(resort: resort)
            }
            .searchable(text: $searchText, prompt: "Search by name or country")
        } detail: {
            if let selectedResort = selectedResort {
                ResortView(resort: selectedResort)
            } else {
                WelcomeView()
            }
        }
        .environment(favourites)
    }
}

#Preview {
    ContentView()
}
