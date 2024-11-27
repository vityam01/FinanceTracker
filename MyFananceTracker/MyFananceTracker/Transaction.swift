//
//  Transaction.swift
//  MyFananceTracker
//
//  Created by Vitya Mandryk on 27.11.2024.
//

import Foundation
import RealmSwift


class Transaction: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var amount: Double
    @Persisted var type: TransactionType
    @Persisted var category: String
    @Persisted var date: Date
    
    enum TransactionType: String, PersistableEnum {
        case income, expense
    }
}
