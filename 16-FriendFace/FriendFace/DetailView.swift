//
//  DetailView.swift
//  FriendFace
//
//  Created by Aarav Sinha on 26/06/24.
//

import SwiftUI

struct DetailView: View {
    var user: User
    var body: some View {
        NavigationStack {
            HStack {
                Circle()
                    .fill(user.isActive ? .green : .gray)
                    .frame(width: 10, height: 10)
                
                Text(user.isActive ? "Online" : "Offline")
            }
            
            List {
                Section("Name") {
                    Text(user.name)
                }
                
                Section("Date registered") {
                    Text("\(user.registered.formatted(date: .long, time: .omitted))")
                }
                Section("Age") {
                    Text(String(user.age))
                }
                
                Section("Company") {
                    Text(user.company)
                }
                
                Section("Email") {
                    Text(user.email)
                }
                
                Section("Address") {
                    Text(user.address)
                }
                
                Section("About") {
                    Text(user.about)
                }
                
                Section("Friends") {
                    ForEach(user.friends) { friend in
                        Text(friend.name)
                    }
                }
            }
            .navigationBarTitle(user.name, displayMode: .inline)
            
        }
    }
}

#Preview {
    var users = [User]()
    let new = User(id: UUID(), isActive: true, name: "A", age: 18, company: "Apple", email: "a@gmail.com", address: "A's house", about: "AAAAAA", registered: Date(), tags: ["c"], friends: [Friend(id: UUID(), name: "B")])
    users.append(new)
    return DetailView(user: users[0]).preferredColorScheme(.dark)
}
