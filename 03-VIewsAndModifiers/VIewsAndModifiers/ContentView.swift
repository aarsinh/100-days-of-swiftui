//
//  ContentView.swift
//  VIewsAndModifiers
//
//  Created by Aarav Sinha on 30/05/24.
//

import SwiftUI

struct ProminentText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundStyle(.blue)
            .padding(5)
        
    }
}

extension View {
    func prominent() -> some View {
        modifier(ProminentText())
    }
}

struct ContentView: View {
    var body: some View {
        Text("Prominent Title")
            .prominent()
    }
}

#Preview {
    ContentView()
}
