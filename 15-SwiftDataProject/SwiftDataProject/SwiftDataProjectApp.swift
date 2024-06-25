//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Aarav Sinha on 20/06/24.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
