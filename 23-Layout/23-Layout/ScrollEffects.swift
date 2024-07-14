//
//  ScrollEffects.swift
//  23-Layout
//
//  Created by Aarav Sinha on 14/07/24.
//

import SwiftUI

struct ScrollEffects: View {
    var body: some View {
        GeometryReader { fullView in
            ScrollView {
                ForEach(0..<50) { index in
                    GeometryReader { proxy in
                        let scale = proxy.frame(in: .global).minY / fullView.size.height / 0.8
                        let hue = min(scale * 0.8, 1.0)
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(Color(hue: hue, saturation: 1, brightness: 1))
                            .rotation3DEffect(
                                .degrees(proxy.frame(in: .global).minY - fullView.size.height / 2) / 5,
                                axis: (x: 0.0, y: 1.0, z: 0.0)
                            )
                            .opacity((proxy.frame(in: .global).minY - 100)/100.0)
                            .scaleEffect(scale < 0.5 ? 0.5 : scale)
                        
                    }
                    .frame(height: 40)
                    
                    
                }
            }
        }
        
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 0) {
//                ForEach(1..<20) { num in
//                    Text("Number \(num)")
//                        .font(.largeTitle)
//                        .padding()
//                        .background(.red)
//                        .frame(width: 200, height: 200)
//                        .visualEffect { content, proxy in
//                            content
//                                .rotation3DEffect(.degrees(-proxy.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
//                        }
//
//                }
//            }
//            .scrollTargetLayout()
//        }
//        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    ScrollEffects()
}
