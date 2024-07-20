//
//  SideBySideViews.swift
//  SnowSeeker
//
//  Created by Aarav Sinha on 19/07/24.
//

import SwiftUI

struct SideBySideViews: View {
    var body: some View {
        NavigationSplitView(preferredCompactColumn: .constant(.detail)) {
            NavigationLink("Primary") {
                Text("primary")
            }
        } detail: {
            Text("content")
                .navigationTitle("Content View")
        }
        .navigationSplitViewStyle(.balanced)
    }
}

#Preview {
    SideBySideViews()
}
