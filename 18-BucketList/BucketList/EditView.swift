//
//  EditView.swift
//  BucketList
//
//  Created by Aarav Sinha on 05/07/24.
//

import SwiftUI

struct EditView: View {
    @State private var viewModel : ViewModel
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    let cvvm: ContentView.ViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later")
                    }
                }
            }
                .toolbar {
//                    ToolbarItem(placement: .topBarLeading) {
//                        Button("Delete", systemImage: "trash") {
//                            cvvm.deleteLocation(id: viewModel.location.id)
//                            dismiss()
//                        }
//                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            var newLocation = viewModel.location
                            newLocation.id = UUID()
                            newLocation.name = viewModel.name
                            newLocation.description = viewModel.description
                            
                            onSave(newLocation)
                            dismiss()
                        }
                    }
                }
                .task {
                    await viewModel.fetchNearbyPlaces()
                }
        }
        
    }
    
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(location: location))
        self.cvvm = ContentView.ViewModel()
    }
}

#Preview {
    EditView(location: .example) { _ in}
}
