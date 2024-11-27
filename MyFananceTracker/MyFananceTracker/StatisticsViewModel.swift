//
//  StatisticsViewModel.swift
//  MyFananceTracker
//
//  Created by Vitya Mandryk on 27.11.2024.
//

import Foundation

class StatisticsViewModel: ObservableObject {
    @Published private(set) var expensesByCategory: [(key: String, value: Double)] = []
    @Published private(set) var totalIncome: Double = 0.0
    @Published private(set) var totalExpenses: Double = 0.0

    private var transactions: [Transaction] = []
    private let repository: TransactionRepository

    init(repository: TransactionRepository = RealmTransactionRepository()) {
        self.repository = repository
        loadTransactions()
    }

    func loadTransactions() {
        transactions = Array(repository.fetchTransactions())
    }

    func updateDates(startDate: Date, endDate: Date) {
        let filteredTransactions = transactions.filter { $0.date >= startDate && $0.date <= endDate }
        
        totalIncome = filteredTransactions.filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
        
        totalExpenses = filteredTransactions.filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }

        expensesByCategory = Dictionary(grouping: filteredTransactions.filter { $0.type == .expense },
                                        by: { $0.category })
            .mapValues { $0.reduce(0) { $0 + $1.amount } }
            .sorted(by: { $0.value > $1.value })
    }
}
