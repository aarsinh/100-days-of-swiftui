//
//  HistoryView.swift
//  DiceRolls
//
//  Created by Aarav Sinha on 15/07/24.
//

import SwiftUI

struct HistoryView: View {
    @Binding var history: [Roll]
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "number")
                Text("/")
                Image(systemName: "dice")
                
                Spacer()
                
                Text("Result")
                Spacer()
                
                Text("Total")
            }
            .font(.title3)
            .bold()
            .foregroundStyle(.white)
            .frame(height: 30)
            .background(.oxfordBlue)
            
            ScrollView {
                VStack {
                    ForEach(history, id: \.self) { roll in
                        HStack {
                            Text("\(roll.number)")
                                .padding(.leading, 5)
                            Text(" / ")
                            Text("\(roll.sides)")
                            Spacer()
                            
                            ForEach(roll.result, id: \.self) { result in
                                Text("\(result)")
                            }
                            .padding(.trailing, 5)
                            Spacer()
                            Text("\(roll.total)")
                                .padding(.trailing, 10)
                        }
                        .frame(height: 25)
                        .background(history.firstIndex(of: roll)! % 2 == 0 ? .lapis : .oxfordBlue)
                        .foregroundStyle(.white)
                        .font(.headline)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    HistoryView(history: .constant([.example]))
        .preferredColorScheme(.dark)
}
