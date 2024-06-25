//
//  ContentView.swift
//  Bookworm
//
//  Created by Aarav Sinha on 20/06/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var books: [Book]
    
    @State private var showingAddScreen = false
    var body: some View {
        NavigationStack {
            Text("Count: \(books.count)")
                .navigationTitle("Bookworm")
                .toolbar {
                    Button("add view", systemImage: "plus") {
                        showingAddScreen.toggle()
                    }
                }
                .sheet(isPresented: $showingAddScreen, content: {
                    AddView()
                })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
