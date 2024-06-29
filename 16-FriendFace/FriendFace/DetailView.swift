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
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(user.name.uppercased()), \(user.age)")
                            .bold()
                            .font(.system(size: 25))
                        Circle()
                            .fill(user.isActive ? .green : .gray)
                            .frame(width: 15, height: 15)
                    }
                    Text(user.company)
                        .font(.system(size: 20))
                    
                    
                    Text("Date Joined: \(user.registered.formatted(date: .long, time: .omitted))")
                        .italic()
                        .foregroundStyle(.gray)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text(user.email)
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Image(systemName: "house.fill")
                        Text(user.address)
                    }
                    .padding(.bottom, 20)
                    
                    Text("About")
                        .font(.system(size: 20))
                        .bold()
                    Text(user.about)
                        .padding(.bottom, 20)
                    
                    Text("Friends")
                        .font(.system(size: 20))
                        .bold()
                    
                    ForEach(user.friends) { friend in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(.gray.opacity(0.2))
                                .frame(height: 30)
                            Text(friend.name)
                                .padding(.leading, 5)
                        }
                        .padding(.bottom, 5)
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .padding()
            .navigationBarTitle(user.name, displayMode: .inline)
            
        }
    }
}

//#Preview {
////    var users = [User]()
////    let new = User(id: UUID(), isActive: true, name: "A", age: 18, company: "Apple", email: "a@gmail.com", address: "A's house", about: "AAAAAA", registered: Date(), tags: ["c"], friends: [Friend(id: UUID(), name: "B")])
////    users.append(new)
//   /* return */DetailView(user: users[0]).preferredColorScheme(.dark)
//}
