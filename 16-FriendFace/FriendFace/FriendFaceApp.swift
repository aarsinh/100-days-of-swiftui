//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Aarav Sinha on 26/06/24.
//

import SwiftUI
import SwiftData

@main
struct FriendFaceApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: User.self)
        } catch {
            fatalError("could not initalise container")
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
//        .modelContainer(for: User.self) { result in
//            do {
//                let container = try result.get()
//                
//                let descriptor = FetchDescriptor<User>()
//                let existingUsers = try container.mainContext.fetchCount(descriptor)
//                guard existingUsers == 0 else { return }
//                
//                guard let url = Bundle.main.url(forResource: "users", withExtension: "json") else {
//                    fatalError("Could not load data")
//                }
//                
//                let data = try Data(contentsOf: url)
//                let users = try JSONDecoder().decode([User].self, from: data)
//                
//                for user in users {
//                    container.mainContext.insert(user)
//                }
//            } catch {
//                print(error)
//            }
//        }
    }
}
