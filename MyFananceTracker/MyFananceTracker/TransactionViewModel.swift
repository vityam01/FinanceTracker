//
//  TransactionViewModel.swift
//  MyFananceTracker
//
//  Created by Vitya Mandryk on 27.11.2024.
//

import Foundation
import SwiftUI
import RealmSwift

class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var totalBalance: Double = 0.0
    @Published var incomeTotal: Double = 0.0
    @Published var expenseTotal: Double = 0.0
    @Published var isAddingIncome = false
    @Published var isAddingExpense = false
    @Published var categories: [String] = ["Food", "Salary", "Fun", "Transport"]
    
    private let repository: TransactionRepository
    private var notificationToken: NotificationToken?
    
    let sharedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    
    init(repository: TransactionRepository = RealmTransactionRepository()) {
        self.repository = repository
        fetchTransactions()
        
        // Observe Realm changes
        if let realmResults = repository.fetchTransactions() as? Results<Transaction> {
            notificationToken = realmResults.observe { [weak self] _ in
                self?.fetchTransactions()
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    var groupedTransactions: [(key: Date, value: [Transaction])] {
        let grouped = Dictionary(grouping: transactions, by: { Calendar.current.startOfDay(for: $0.date) })
        return grouped.sorted { $0.key > $1.key }
    }
    
    func formatDate(_ date: Date) -> String {
        return sharedDateFormatter.string(from: date)
    }
    
    func addCategory(_ category: String) {
        let trimmedCategory = category.trimmingCharacters(in: .whitespacesAndNewlines)
        if !categories.contains(trimmedCategory), !trimmedCategory.isEmpty {
            categories.append(trimmedCategory)
        }
    }

    
    func fetchTransactions() {
        let results = repository.fetchTransactions()
        transactions = Array(results)
        calculateTotals()
    }
    
    func updateTransaction(_ transaction: Transaction, with updatedData: Transaction) {
        repository.updateTransaction(transaction, with: updatedData)
        fetchTransactions()
    }
    
    func addTransaction(amount: Double, type: Transaction.TransactionType, category: String, date: Date) {
        let transaction = Transaction()
        transaction.amount = amount
        transaction.type = type
        transaction.category = category
        transaction.date = date
        repository.addTransaction(transaction)
        fetchTransactions()
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        repository.deleteTransaction(transaction)
        fetchTransactions()
    }
    
    func calculateTotals() {
        incomeTotal = transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        expenseTotal = transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
        totalBalance = incomeTotal - expenseTotal
    }
    
    func filterTransactions(by startDate: Date, endDate: Date) -> [(key: Date, value: [Transaction])] {
        let filteredTransactions = transactions.filter {
            $0.date >= startDate && $0.date <= endDate
        }
        let grouped = Dictionary(grouping: filteredTransactions, by: { Calendar.current.startOfDay(for: $0.date) })
        return grouped.sorted { $0.key > $1.key }
    }
}

