//
//  AddTransactionView.swift
//  MyFananceTracker
//
//  Created by Vitya Mandryk on 27.11.2024.
//

import Foundation
import SwiftUI

struct AddTransactionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TransactionViewModel

    var transactionToEdit: Transaction? = nil
    var type: Transaction.TransactionType? = nil

    @State private var amount: String
    @State private var category: String
    @State private var date: Date
    @State private var selectedType: Transaction.TransactionType
    @State private var isAddingNewCategory: Bool = false
    @State private var newCategory: String = ""

    init(viewModel: TransactionViewModel, type: Transaction.TransactionType? = nil, transactionToEdit: Transaction? = nil) {
        self.viewModel = viewModel
        self.type = type
        self.transactionToEdit = transactionToEdit

        _amount = State(initialValue: transactionToEdit?.amount.description ?? "")
        _category = State(initialValue: transactionToEdit?.category ?? viewModel.categories.first ?? "")
        _date = State(initialValue: transactionToEdit?.date ?? Date())
        _selectedType = State(initialValue: transactionToEdit?.type ?? type ?? .income)
    }

    var body: some View {
        NavigationView {
            Form {
                // Amount Input
                Section(header: Text(transactionToEdit == nil ? "Add Transaction" : "Edit Transaction")) {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .onChange(of: amount) { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered.filter({ $0 == "." }).count > 1 {
                                self.amount = String(filtered.dropLast())
                            } else {
                                self.amount = filtered
                            }
                        }
                }

                // Category Input
                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $category) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                        Text("Add New Category").tag("Add New")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: category) { newValue in
                        if newValue == "Add New" {
                            isAddingNewCategory = true
                            newCategory = ""
                        } else {
                            isAddingNewCategory = false
                        }
                    }

                    if isAddingNewCategory {
                        TextField("Enter New Category", text: $newCategory)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onSubmit {
                                if !newCategory.isEmpty {
                                    addNewCategoryAndUpdateSelection()
                                }
                            }
                            .padding(.top, 8)
                    }
                }

                // Date Input
                Section(header: Text("Date")) {
                    DatePicker("Transaction Date", selection: $date, displayedComponents: .date)
                }

                // Type Input
                Section(header: Text("Type")) {
                    Picker("Transaction Type", selection: $selectedType) {
                        Text("Income").tag(Transaction.TransactionType.income)
                        Text("Expense").tag(Transaction.TransactionType.expense)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                // Save Button
                Section {
                    Button(action: saveTransaction) {
                        Text(transactionToEdit == nil ? "Add" : "Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedType == .income ? Color.green : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle(transactionToEdit == nil ? "Add Transaction" : "Edit Transaction")
        }
    }

    private func addNewCategoryAndUpdateSelection() {
        if !newCategory.isEmpty {
            viewModel.addCategory(newCategory)
            category = newCategory
            isAddingNewCategory = false
        }
    }

    private func saveTransaction() {
        guard let transactionAmount = Double(amount), !category.isEmpty else { return }

        if isAddingNewCategory, !newCategory.isEmpty {
            addNewCategoryAndUpdateSelection()
        }

        if let transactionToEdit = transactionToEdit {
            // Update existing transaction
            let updatedTransaction = Transaction()
            updatedTransaction.id = transactionToEdit.id
            updatedTransaction.amount = transactionAmount
            updatedTransaction.type = selectedType
            updatedTransaction.category = category
            updatedTransaction.date = date
            viewModel.updateTransaction(transactionToEdit, with: updatedTransaction)
        } else {
            // Add new transaction
            viewModel.addTransaction(amount: transactionAmount, type: selectedType, category: category, date: date)
        }

        presentationMode.wrappedValue.dismiss()
    }
}




