//
//  AlertAndSheet.swift
//  SnowSeeker
//
//  Created by Aarav Sinha on 19/07/24.
//

import SwiftUI

struct User: Identifiable {
    var id = "Taylor Swift"
}

struct AlertAndSheet: View {
    @State private var selectedUser: User? = nil
    @State private var isShowingUser = false
    
    var body: some View {
        
//        Button("tap me") {
//            isShowingUser = true
//        }
//        .alert("Welcome", isPresented: $isShowingUser, presenting: selectedUser) { user in
//            Button(user.id) { }
//        }
        
        Button("Tap me") {
            selectedUser = User()
        }
        .sheet(item: $selectedUser) { user in
            Text(user.id)
                .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    AlertAndSheet()
}
