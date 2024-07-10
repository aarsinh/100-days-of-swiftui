//
//  Border.swift
//  Hot Propsects
//
//  Created by Aarav Sinha on 09/07/24.
//

import SwiftUI

struct BorderModifier: ViewModifier {
       func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.primary, lineWidth: 2)
                    .frame(width: 367, height:39)
                )
        
    }
}

extension View {
    func customBorder() -> some View{
        self.modifier(BorderModifier())
    }
}
