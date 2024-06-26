//
//  Expenses.swift
//  iExpense
//
//  Created by Aarav Sinha on 25/06/24.
//

import Foundation
import SwiftData

@Model
class Expense {
    var name: String
    var type: String
    var amount: Double
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}


