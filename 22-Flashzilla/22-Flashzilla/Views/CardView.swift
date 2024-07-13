//
//  CardView.swift
//  22-Flashzilla
//
//  Created by Aarav Sinha on 10/07/24.
//

import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    let card: Card
    var removal: ((Bool) -> Void)? = nil
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor 
                    ? .white
                    : .white.opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    accessibilityDifferentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25)
                        .fill(backgroundColor(offset: offset))
                )
                .shadow(radius: 10)
            
            VStack {
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.question)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                } else {
                    Text(card.question)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    
                    if isShowingAnswer {
                        withAnimation {
                            Text(card.answer)
                                .font(.title)
                                .foregroundStyle(.black.opacity(0.7))
                        }
                    }
                }
                
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .opacity(2 - Double(abs(offset.width/50)))
        .accessibilityAddTraits(.isButton)
        .offset(x: offset.width * 5)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        if offset.width > 0 {
                            removal?(false)
                        } else {
                            removal?(true)
                            isShowingAnswer = false
                            offset = .zero
                        }
                    } else {
                        offset = .zero
                    }
                    
                }
            )
        .onTapGesture {
            isShowingAnswer = true
        }
        .animation(.bouncy, value: offset)
    }
    
    func backgroundColor(offset: CGSize) -> Color {
        if offset.width > 0 { return .green }
        if offset.width < 0 { return .red }
        return .white
    }
}




#Preview {
    CardView(card: .example)
}
