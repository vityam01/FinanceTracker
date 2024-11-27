//
//  RealmTransactionRepository.swift
//  MyFananceTracker
//
//  Created by Vitya Mandryk on 27.11.2024.
//

import Foundation
import RealmSwift

protocol TransactionRepository {
    func fetchTransactions() -> Results<Transaction>
    func addTransaction(_ transaction: Transaction)
    func deleteTransaction(_ transaction: Transaction)
    func updateTransaction(_ transaction: Transaction, with updatedData: Transaction)
}

class RealmTransactionRepository: TransactionRepository {
    private let realm = try! Realm()
    
    func fetchTransactions() -> Results<Transaction> {
        return realm.objects(Transaction.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    func addTransaction(_ transaction: Transaction) {
        try? realm.write {
            realm.add(transaction)
        }
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        try? realm.write {
            realm.delete(transaction)
        }
    }
    
    func updateTransaction(_ transaction: Transaction, with updatedData: Transaction) {
        try? realm.write {
            transaction.amount = updatedData.amount
            transaction.type = updatedData.type
            transaction.category = updatedData.category
            transaction.date = updatedData.date
        }
    }
}
