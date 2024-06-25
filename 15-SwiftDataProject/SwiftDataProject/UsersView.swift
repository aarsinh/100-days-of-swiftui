//
//  UsersView.swift
//  SwiftDataProject
//
//  Created by Aarav Sinha on 24/06/24.
//

import SwiftUI
import SwiftData

struct UsersView: View {
    @Query var users: [User]
    @Environment(\.modelContext) var modelContext
    var body: some View {
        List(users) { user in
            HStack {
                Text(user.name)
                Spacer()
                
                Text(String(user.jobs.count))
                    .fontWeight(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 10))
                    
            }
        }
    }
    
    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
        _users = Query(filter: #Predicate<User> { user in
            user.joinDate >= minimumJoinDate
        }, sort: sortOrder)
    }
}

#Preview {
    UsersView(minimumJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self)
}
