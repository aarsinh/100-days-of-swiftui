//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Aarav Sinha on 20/06/24.
//

import SwiftUI
import SwiftData

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
