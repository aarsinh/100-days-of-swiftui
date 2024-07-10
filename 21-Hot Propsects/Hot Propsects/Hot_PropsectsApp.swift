//
//  Hot_PropsectsApp.swift
//  Hot Propsects
//
//  Created by Aarav Sinha on 08/07/24.
//

import SwiftUI
import SwiftData

@main
struct Hot_PropsectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
