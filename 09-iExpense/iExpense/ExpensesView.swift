//
//  ExpensesView.swift
//  iExpense
//
//  Created by Aarav Sinha on 25/06/24.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Query var expenses: [Expense]
    @Environment(\.modelContext) var modelContext

    var body: some View {
        if expenses.isEmpty {
            ContentUnavailableView("No expenses", systemImage: "creditcard.trianglebadge.exclamationmark")
        }
        List {
            ForEach(expenses) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.type)
                    }
                    
                    Spacer()
                    
                    Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "INR"))
                        .foregroundStyle(changeColor(amount: item.amount))
                }
            }
            .onDelete(perform: deleteExpense)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink() {
                    AddView(expenses: expenses)
                } label: {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
        }
    }
    
    func deleteExpense(at offsets: IndexSet) {
        for offset in offsets {
            let expense = expenses[offset]
            modelContext.delete(expense)
        }
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
    
    init(sortOrder: [SortDescriptor<Expense>], filterBy: String) {
        _expenses = Query(filter: #Predicate<Expense> { expense in
            expense.type.localizedStandardContains(filterBy) || expense.name.localizedStandardContains(filterBy) || filterBy.isEmpty
        }, sort: sortOrder)
    }
}

#Preview {
    ExpensesView(sortOrder: [SortDescriptor(\Expense.name)], filterBy: "")
}
