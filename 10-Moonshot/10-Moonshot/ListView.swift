//
//  ListView.swift
//  10-Moonshot
//
//  Created by Aarav Sinha on 10/06/24.
//

import SwiftUI

struct ListView: View {
    let missions: [Mission]
    let astronauts: [String: Astronaut]
    var body: some View {
        List(missions) { mission in
            NavigationLink(destination: MissionView(mission: mission, astronauts: astronauts)){
                HStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        Text(mission.formattedLaunchDate)
                    }
                }
            }
            .listRowBackground(Color.darkBackground)
            
        }
        .listStyle(.plain)
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    return ListView(missions: missions, astronauts: astronauts)
}
