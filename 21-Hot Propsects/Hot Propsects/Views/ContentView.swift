//
//  ContentView.swift
//  Hot Propsects
//
//  Created by Aarav Sinha on 08/07/24.
//


import SwiftUI
import UserNotifications
import SwiftData

struct ContentView: View {

    var body: some View {
        TabView {
            SortPropspects(filter: .none)
                .tabItem { Label("Everyone", systemImage: "person.3") }
            
            SortPropspects(filter: .contacted)
                .tabItem { Label("Contacted", systemImage: "checkmark.circle") }
            
            SortPropspects(filter: .uncontacted)
                .tabItem { Label("Uncontacted", systemImage: "questionmark.diamond") }
            
            MeView()
                .tabItem { Label("Me", systemImage: "person.crop.square") }
        }
    }
}

#Preview {
    ContentView()
}
