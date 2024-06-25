//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by Aarav Sinha on 20/06/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext

    @State private var showingUpcomingOnly = false

    @State private var sortOrder = [
        SortDescriptor(\User.name),
        SortDescriptor(\User.joinDate)
    ]
//  
//    @Query(filter: #Predicate<User> { user in
//        user.name.localizedStandardContains("R") &&
//        user.city == "London"
//    }, sort: \User.name) var users: [User]

    var body: some View {
        NavigationStack {
            UsersView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
                .navigationTitle("Users")
                .toolbar {
                Button("Add Samples", systemImage: "plus") {
//                    try? modelContext.delete(model: User.self)
//                    let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
//                    let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
//                    let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
//                    let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))
//                    
//                    modelContext.insert(first)
//                    modelContext.insert(second)
//                    modelContext.insert(third)
//                    modelContext.insert(fourth)
                    
                    addSample()
                }
                
                Button(showingUpcomingOnly ? "Show everyone" : "Show upcoming") {
                    showingUpcomingOnly.toggle()
                }
                
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name")
                            .tag([
                                SortDescriptor(\User.name),
                                SortDescriptor(\User.joinDate),
                            ])
                        
                        Text("Sort by Join Date")
                            .tag([
                                SortDescriptor(\User.joinDate)
                            ])
                    }
                }
                       
            }
        }
    }
    func addSample() {
        let user1 = User(name: "Piper Chapman", city: "New York", joinDate: .now)
        let job1 = Job(name: "Software Developer", priority: 5)
        let job2 = Job(name: "Freelance Artist", priority: 3)
        
        modelContext.insert(user1)
        user1.jobs.append(job1)
        user1.jobs.append(job2)
    }
}

#Preview {
    ContentView()
}
