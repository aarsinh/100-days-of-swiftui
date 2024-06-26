//
//  AddView.swift
//  iExpense
//
//  Created by Aarav Sinha on 08/06/24.
//

import SwiftUI

struct AddView: View {
    var expenses: [Expense]
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types = ["Business", "Personal", "Home", "Food"]
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "INR"))
            }
            .navigationTitle("Add New Expense")
            .toolbar {
                Button("Save") {
                    let expense = Expense(name: name, type: type, amount: amount)
                    modelContext.insert(expense)
                    dismiss()
                }
                .disabled(name.isEmpty)
            }
        }
    }
}

#Preview {
    AddView(expenses: [Expense]()).preferredColorScheme(.dark)
}
