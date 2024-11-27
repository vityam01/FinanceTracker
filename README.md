# FinanceTracker


User Guide for Personal Finance Tracker

Overview

The Personal Finance Tracker is a simple and user-friendly application designed to help you manage your personal finances. It allows you to:

- Track income and expenses.
- View transaction history.
- Analyze spending with statistical insights.


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Features

1. Dashboard:
Displays your total balance (Income - Expenses).
Provides quick access to "Add Income" and "Add Expense" buttons.

2. Add Transactions:
Enter the transaction amount, type (Income/Expense), category, and date.
Choose an existing category or create a new one.

3. Transaction History:
View all transactions organized by date.
Edit or delete any transaction as needed.

4. Statistics:
Visualize spending by category with a pie chart.
View total income and expenses for a selected period.


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


How to Use

1. Home Screen:
View your total balance at the top.
Tap "Add Income" or "Add Expense" to add a transaction.

2. Add Transaction:
Input the transaction details: amount, category, date, and type.
Save the transaction.

3. View History:
Scroll through the transaction history to review past entries.
Tap a transaction to edit or delete it.

4. Analyze Statistics:
Navigate to the Statistics page using the "Statistic" button in the toolbar.
Adjust the date range to view statistics for a specific period.
Review the pie chart and total amounts for income and expenses.


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Documentation for Developers
Project Structure

1. Model:
Transaction.swift: Represents a financial transaction with fields like amount, type, category, and date.
Data is stored using Realm for efficient local storage.

2. Repository:
RealmTransactionRepository.swift: Handles database operations such as fetching, adding, updating, and deleting transactions. Implements the TransactionRepository protocol for abstraction.

3. ViewModel:
TransactionViewModel.swift: Manages the business logic for transactions, including filtering, grouping, and calculating totals.
StatisticsViewModel.swift: Focuses on statistical analysis, including income, expenses, and grouped expenses by category.

4. View:
ContentView.swift: The main dashboard displaying balance and transaction list.
AddTransactionView.swift: A form for adding or editing transactions.
StatisticsView.swift: Displays a pie chart and totals for the selected date range.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Key Technologies

- SwiftUI: Modern declarative UI framework for building the app interface.
- Realm: A lightweight database for efficient local data storage.
- MVVM Architecture: Ensures a clear separation of concerns between UI and business logic.
- Charts Framework: Used for rendering the pie chart in the Statistics view.


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Setup Instructions

1. Clone the repository to your local machine:
git clone <repository_url>

2. Open the project in Xcode:
open MyFinanceTracker.xcodeproj

3. Install dependencies (if applicable) via Swift Package Manager (SPM).
4. Build and run the app on a simulator or physical device (iOS 14+ required).

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Future Enhancements

Add recurring transactions.
Support for multiple currencies.
Secure cloud synchronization for backups.

