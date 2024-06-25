//
//  EditUser.swift
//  SwiftDataProject
//
//  Created by Aarav Sinha on 20/06/24.
//

import SwiftUI
import SwiftData

struct EditUser: View {
    @Bindable var user: User
    
    var body: some View {
        Form {
            TextField("Name", text: $user.name)
            TextField("City", text: $user.city)
            DatePicker("Join date", selection: $user.joinDate)
        }
        .navigationBarTitle("Edit User", displayMode: .inline)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, configurations: config)
        let user = User(name: "aarav", city: "blr", joinDate: .now)
        return EditUser(user: user)
            .modelContainer(container)
    } catch {
        return Text(error.localizedDescription)
    }
    
}
