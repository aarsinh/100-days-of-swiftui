//
//  ContentView.swift
//  10-Moonshot
//
//  Created by Aarav Sinha on 09/06/24.
//

import SwiftUI

struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}

struct Mission: Codable, Identifiable {
    struct Crew: Codable {
        let name: String
        let role: String
    }
    
    let id: Int
    let description: String
    let crew: [Crew]
    let launchDate: Date?
    
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "Date: N/A"
    }
}

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
   
    @State private var showingList = false
    
    var body: some View {
        NavigationStack {
            Group {
                if showingList {
                    ListView(missions: missions, astronauts: astronauts)
                }
                else {
                    GridView(missions: missions, astronauts: astronauts)
                }
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                Button(showingList ? "Grid View" : "List View") {
                    showingList.toggle()
                }
            }
        }
    }
}
    
#Preview {
    ContentView()
}
