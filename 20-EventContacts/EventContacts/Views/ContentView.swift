//
//  ContentView.swift
//  EventContacts
//
//  Created by Aarav Sinha on 06/07/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
        @State private var viewModel = ViewModel()
    
        var body: some View {
        NavigationStack {
            if viewModel.people.isEmpty {
                ContentUnavailableView("No contacts added yet", systemImage: "person.badge.plus")
            }
            
            List {
                ForEach(viewModel.people.sorted()) { person in
                    NavigationLink(destination: DetailView(person: person)) {
                        HStack {
                            person.image
                                .resizable()
                                .frame(width: 75, height: 100)
                                .clipShape(.rect(cornerRadius: 10))
                                .padding(.trailing, 20)
                            
                            Text(person.name)
                                .font(.headline)
                        }
                    }
                }
                .onDelete(perform: deleteContact)
            }
            .navigationTitle("Event Contacts")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Add", systemImage: "plus") {
                        viewModel.showingAddContact = true
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddContact) {
                AddView(people: $viewModel.people)
            }
                
        }
    }
    
    func deleteContact(at offsets: IndexSet) {
        viewModel.people.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
