//
//  PickerView.swift
//  DiceRolls
//
//  Created by Aarav Sinha on 14/07/24.
//

import SwiftUI

struct PickerView: View {
    @Binding var diceSides: Int
    @Binding var diceNumber: Int
    var body: some View {
        HStack {
            Image(systemName: "number")
            Text("Number of Dice")
            Spacer()
        }
        .foregroundStyle(.white)
        .padding(.horizontal)
        
        Picker("Number of Dice", selection: $diceNumber) {
            ForEach(1..<7) { num in
                Text("\(num)").tag(num)
            }
        }
        .customPicker()
        .padding(.bottom, 14)
        
        HStack {
            Image(systemName: "dice")
            Text("Sides")
            Spacer()
        }
        .foregroundStyle(.white)
        .padding(.horizontal)
        
        Picker("Number of sides", selection: $diceSides) {
            Text("4").tag(4)
            Text("6").tag(6)
            Text("8").tag(8)
            Text("10").tag(10)
            Text("20").tag(20)
            Text("100").tag(100)
        }
        .customPicker()
    }
}

struct CustomPicker: ViewModifier {
    func body(content: Content) -> some View {
        content
            .pickerStyle(.segmented)
            .background(.blueNCS)
            .clipShape(.rect(cornerRadius: 8))
            .padding(.horizontal)
    }
}

extension View {
    func customPicker() -> some View {
        modifier(CustomPicker())
    }
}
#Preview {
    PickerView(diceSides: .constant(6), diceNumber: .constant(2))
        .preferredColorScheme(.dark)
}
