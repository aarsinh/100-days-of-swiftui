//
//  ContentView-ViewModel.swift
//  EventContacts
//
//  Created by Aarav Sinha on 06/07/24.
//

import Foundation
import PhotosUI
import Observation
import SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        var showingAddContact = false
        var people: [Person]
        
        let savePath = URL.documentsDirectory.appending(path: "SavedContacts")
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                people = try JSONDecoder().decode([Person].self, from: data)
            } catch {
                people = []
                print(error)
            }
        }
    }
}
