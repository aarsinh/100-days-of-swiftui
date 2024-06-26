//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Aarav Sinha on 08/06/24.
//

import SwiftUI
import SwiftData

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Expense.self)
    }
}
