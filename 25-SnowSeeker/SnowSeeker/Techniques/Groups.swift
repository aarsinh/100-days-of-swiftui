//
//  Groups.swift
//  SnowSeeker
//
//  Created by Aarav Sinha on 19/07/24.
//

import SwiftUI
struct UserView: View {
    var body: some View {
        Group {
            Text("Name: Aarav")
            Text("Country: Indian")
            Text("Pets: None")
        }
        .font(.title3)
    }
}
struct Groups: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
        var body: some View {
        ViewThatFits {
            VStack(content: UserView.init)
            HStack(content: UserView.init)
        }
    }
}

#Preview {
    Groups()
}
