//
//  Transaction.swift
//  Money Control
//
//  Created by Robert Nersesyan on 28.06.21.
//

import Foundation

class Transaction: Codable {
    var sum: Double = 0
    var name: String = ""
    var date: String = ""
    var isExpense: Bool = true
    var category = ""
    
    init(sum: Double, name: String, date: String, isExpense: Bool, category: String) {
        self.sum = sum
        self.name = name
        self.date = date
        self.isExpense = isExpense
        self.category = category
    }
}
