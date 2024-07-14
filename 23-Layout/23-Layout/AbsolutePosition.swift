//
//  AbsolutePosition.swift
//  23-Layout
//
//  Created by Aarav Sinha on 13/07/24.
//

import SwiftUI

struct AbsolutePosition: View {
    var body: some View {
        Text("Hello, World!")
            .offset(x: 100, y: 100)
            .background(.red)
    }
}

#Preview {
    AbsolutePosition()
}
