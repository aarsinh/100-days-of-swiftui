//
//  ContentView.swift
//  iExpense
//
//  Created by Aarav Sinha on 08/06/24.
//

import SwiftUI
import Observation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decoded
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack {
                            Text(item.name)
                                .font(.headline)
                                .padding(.bottom, 5)
                            Text(item.type)
                        }
                        
                        Spacer()
                        Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "INR"))
                            .foregroundStyle(changeColor(amount: item.amount))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("add expense", systemImage: "plus") {
                        showingAddExpense = true
                    }
                    .sheet(isPresented: $showingAddExpense) {
                        AddView(expenses: expenses)
                    }
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func changeColor(amount: Double) -> Color {
        switch amount {
            case 0..<500:
                    return .green
            
            case 500..<1000:
                return .orange
            
            default:
                return .red
        }
    }
}


#Preview {
    ContentView().preferredColorScheme(.dark)
}
