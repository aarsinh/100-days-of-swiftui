//
//  ContentView.swift
//  Animations
//
//  Created by Aarav Sinha on 03/06/24.
//

import SwiftUI

struct CornerRotationModifier: ViewModifier {
    let angle: Double
    let around: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(angle), anchor: around)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotationModifier(angle: -90, around: .topLeading),
                  identity: CornerRotationModifier(angle: 0, around: .topLeading))
    }
}

struct ContentView: View {
    @State private var isShowingRed = false
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 100, height: 100)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
            
        
        
    }
                   
}


#Preview {
    ContentView()
}
