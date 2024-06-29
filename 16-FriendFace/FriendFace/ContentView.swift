//
//  ContentView.swift
//  FriendFace
//
//  Created by Aarav Sinha on 26/06/24.
//

import SwiftUI
import SwiftData

extension URLSession {
    func decode<T: Codable>(
        _ type: T.Type = T.self,
        from url: URL,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .deferredToData,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
    ) async throws -> T {
        let (data, _) = try await data(from: url)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dataDecodingStrategy = dataDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy
        
        let decoded = try decoder.decode(T.self, from: data)
        return decoded
    }
}

struct ContentView: View {
    @Query var users: [User]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            List(users) { user in
                NavigationLink(destination: DetailView(user: user)) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(.gray)
                                .frame(width: 50, height: 60)
                            Text(String(user.name.first!))
                                .foregroundStyle(.white)
                            Circle()
                                .stroke(user.isActive ? .green : .clear, lineWidth: 2)
                                .frame(width: 55, height: 60)
                            
                        }
                        .padding(.trailing, 10)
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .padding(.bottom, 5)
                            Text(user.email)
                                .font(.system(size: 13))
                        }
                    }
                    .navigationTitle("FriendFace")
                    .task {
                        if users.isEmpty {
                            await loadUsers()
                            print(users.count)
                        }
                    }
                }
            }
        }
    }
    
    func loadUsers() async {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Could not find URL")
            return
        }
        
        do {
            if let decodedUsers = try await URLSession.shared.decode([User]?.self, from: url) {
                for user in decodedUsers {
                    modelContext.insert(user)
                }
            }
        } catch {
            print(error)
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}


