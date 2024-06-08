//
//  ContentView.swift
//  WeSplit
//
//  Created by Aarav Sinha on 26/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 20
    @FocusState private var amountInFocus: Bool
    
    var total: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount/100 * tipSelection
        let total = tipValue + checkAmount
        return total
    }
    
    var totalPerPerson: Double {
        let people = Double(numberOfPeople + 2)
        let amountPerPerson = total/people
        return amountPerPerson
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Total Amount and People"){
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "INR"))
                        .keyboardType(.decimalPad)
                        .focused($amountInFocus)
                    
                    Picker("Number of People", selection: $numberOfPeople){
                        ForEach(2..<100){
                            Text("\($0)")
                        }
                        
                    }
                }
                
                Section("Tip Percentage") {
                    Picker("Tip Percentage", selection: $tipPercentage){
                        ForEach(0..<101){
                            Text($0, format: .percent)
                        }
                    }.pickerStyle(.navigationLink)
                }
                
                Section("Total Amount") {
                    Text(total, format: .currency(code: Locale.current.currency?.identifier ?? "INR"))
                        .foregroundStyle(tipPercentage == 0 ? .red : .black)
                }
                
                Section("Amount per person") {
                    Text(totalPerPerson , format: .currency(code: Locale.current.currency?.identifier ?? "INR"))
                }
            }
            .toolbar {
                if amountInFocus {
                    Button("Done") {
                        amountInFocus = false
                    }
                }
            }
            .navigationTitle("WeSplit")
        }
    }
}

#Preview {
    ContentView()
}
