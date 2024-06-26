//
//  ContentView.swift
//  FriendFace
//
//  Created by Aarav Sinha on 26/06/24.
//

import SwiftUI

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
    @State private var users = [User]()
    
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
                }
            }
            .navigationTitle("FriendFace")
            .task {
                if let decodedUsers = await getUsers() {
                    users = decodedUsers
                }
            }
        }
    }
    
    func getUsers() async -> [User]? {
        let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let decodedData = try await URLSession.shared.decode([User].self, from: url)
            return decodedData
        } catch {
            print(error)
        }
        
        return nil
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
