//
//  ContentView.swift
//  MyFananceTracker
//
//  Created by Vitya Mandryk on 27.11.2024.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = TransactionViewModel()
    @State private var editingTransaction: Transaction? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                balanceView
                
                actionButtons
                
                transactionList
            }
            .navigationTitle("Finance")
            .sheet(isPresented: $viewModel.isAddingIncome) {
                AddTransactionView(viewModel: viewModel, type: Transaction.TransactionType.income)
            }
            .sheet(isPresented: $viewModel.isAddingExpense) {
                AddTransactionView(viewModel: viewModel, type: Transaction.TransactionType.expense)
            }
            .sheet(item: $editingTransaction) { transaction in
                AddTransactionView(viewModel: viewModel, transactionToEdit: transaction)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: StatisticsView()) {
                        Text("Statistic")
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

private extension ContentView {
    // Balance View
    var balanceView: some View {
        Text("Balance: \(viewModel.totalBalance, specifier: "%.2f") ₴")
            .font(.title)
            .padding()
    }
    
    // Action Buttons
    var actionButtons: some View {
        HStack {
            Button(action: { viewModel.isAddingIncome = true }) {
                Text("Add income")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: { viewModel.isAddingExpense = true }) {
                Text("Add expense")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    // Transaction List
    var transactionList: some View {
        List {
            ForEach(viewModel.groupedTransactions, id: \.key) { date, transactions in
                Section(header: Text(viewModel.formatDate(date))) {
                    transactionSection(transactions: transactions)
                }
            }
        }
    }


    private func transactionSection(transactions: [Transaction]) -> some View {
        ForEach(transactions) { transaction in
            TransactionRow(transaction: transaction)
                .swipeActions {
                    deleteButton(for: transaction)
                    editButton(for: transaction)
                }
        }
    }

    private func deleteButton(for transaction: Transaction) -> some View {
        Button(role: .destructive) {
            viewModel.deleteTransaction(transaction)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }

    private func editButton(for transaction: Transaction) -> some View {
        Button {
            editingTransaction = transaction
        } label: {
            Label("Edit", systemImage: "pencil")
        }
        .tint(.blue)
    }
}
