//
//  ContentView.swift
//  iExpense
//
//  Created by Aarav Sinha on 08/06/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var sortOrder = [
        SortDescriptor(\Expense.name),
        SortDescriptor(\Expense.amount)
    ]
    @State private var filterBy = ""
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            ExpensesView(sortOrder: sortOrder, filterBy: filterBy)
                .searchable(text: $filterBy, 
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: Text("Filter by name or type of expense"))
                .navigationTitle("iExpense")
                .toolbar {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by Name")
                                .tag([SortDescriptor(\Expense.name),
                                     SortDescriptor(\Expense.amount)])
                            
                            Text("Sort by Expense")
                                .tag([SortDescriptor(\Expense.amount),
                                      SortDescriptor(\Expense.name)
                                     ])
                        }
                    }
                }

        }
    }
}


#Preview {
    ContentView().preferredColorScheme(.dark)
}
