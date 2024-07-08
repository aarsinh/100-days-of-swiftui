//
//  AddView.swift
//  EventContacts
//
//  Created by Aarav Sinha on 06/07/24.
//

import SwiftUI
import PhotosUI

struct AddView: View {
    @State private var finalImage: Image?
    @State private var selectedImage: PhotosPickerItem?
    @Binding var people: [Person]
    @State private var uiImage: UIImage?
    @State private var photoData: Data?
    @State private var name = ""
    @Environment(\.dismiss) var dismiss
    
    @State private var showingEmptyField = false
    
    private let locationFetcher = LocationFetcher()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Photo") {
                    PhotosPicker(selection: $selectedImage) {
                        if finalImage != nil {
                            finalImage?
                                .resizable()
                                .scaledToFit()
                        } else {
                            ContentUnavailableView("No photo", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                        }
                    }
                    .buttonStyle(.plain)
                    .onChange(of: selectedImage, loadImage)
                    .padding(.vertical, 20)
                    
                }
                if finalImage != nil {
                    Section {
                        TextField("Name", text: $name)
                    }
                }
            }
            .navigationTitle("Add contact")
            .toolbar {
                Button("Save", action: saveContact)
            }
            .alert("Empty Fields", isPresented: $showingEmptyField) {
                
            } message: {
                Text("Please make sure you have selected a photo and entered the name")
            }
        }
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedImage?.loadTransferable(type: Data.self) else { return }
            photoData = imageData
            guard let uiImage = UIImage(data: imageData) else { return }
            
            finalImage = Image(uiImage: uiImage)
        }
    }
    
    let savePath = URL.documentsDirectory.appending(path: "SavedContacts")
    
    func saveContact() {
        guard !name.isEmpty else {
            showingEmptyField = true
            return
        }
        
        locationFetcher.start()
        
        locationFetcher.onLocationUpdate  = { location in
            var person = Person(name: name, photoData: photoData!)
            
            if let location = location {
                person.latitude = location.latitude
                person.longitude = location.longitude
                person.locationSet = true
                print("location set")
            } else {
                print("location could not be set")
            }
            
            people.append(person)
            
            do {
                let data = try JSONEncoder().encode(people)
                print("encoded")
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
                print("written")
            } catch {
                print(error)
            }
            
            locationFetcher.manager.stopUpdatingLocation()
            locationFetcher.onLocationUpdate = nil
            dismiss()
    }
}
    
    init(finalImage: Image? = nil, selectedImage: PhotosPickerItem? = nil, people: Binding<[Person]>, uiImage: UIImage? = nil, photoData: Data? = nil, name: String = "", showingEmptyField: Bool = false) {
            self._finalImage = State(initialValue: finalImage)
            self._selectedImage = State(initialValue: selectedImage)
            self._people = people
            self._uiImage = State(initialValue: uiImage)
            self._photoData = State(initialValue: photoData)
            self._name = State(initialValue: name)
            self._showingEmptyField = State(initialValue: showingEmptyField)
        }
    
}

#Preview {
    AddView(people: .constant([Person]()))
}
