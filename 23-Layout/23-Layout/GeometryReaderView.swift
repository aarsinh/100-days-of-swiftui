//
//  GeometryReaderView.swift
//  23-Layout
//
//  Created by Aarav Sinha on 14/07/24.
//

import SwiftUI

struct GeometryReaderView: View {
    var body: some View {
        OuterView()
            .background(.red)
            .coordinateSpace(name: "Custom")
    }
}

struct OuterView: View {
    var body: some View {
        Text("Top")
        InnerView()
        Text("Bottom")
    }
}

struct InnerView: View {
    var body: some View {
        HStack{
            Text("Left")
            GeometryReader { proxy in
                Text("Center")
                    .background(.blue)
                    .onTapGesture { print("Global center: \(proxy.frame(in: .global).midX) x \(proxy.frame(in: .global).midY)")
                                    print("Custom center: \(proxy.frame(in: .named("Custom")).midX) x \(proxy.frame(in: .named("Custom")).midY)")
                                    print("Local center: \(proxy.frame(in: .local).midX) x \(proxy.frame(in: .local).midY)")
                    }
            }
            .background(.orange)
            Text("Right")
        }
    }
}

#Preview {
    GeometryReaderView()
}
