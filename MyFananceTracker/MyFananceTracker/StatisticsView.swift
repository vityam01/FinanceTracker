//
//  StatisticsView.swift
//  MyFananceTracker
//
//  Created by Vitya Mandryk on 27.11.2024.
//

import Foundation
import SwiftUI
import Charts


struct StatisticsView: View {
    @StateObject private var viewModel: StatisticsViewModel = StatisticsViewModel()
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate: Date = Date()

    var body: some View {
        VStack {
            if UIDevice.current.userInterfaceIdiom == .pad {
                Spacer()
            }
            Text("Statistics")
                .font(.largeTitle)
                .padding()

            Spacer()
            // Date Pickers
            VStack {
                DatePicker("From", selection: $startDate, displayedComponents: .date)
                    .onChange(of: startDate) { _ in viewModel.updateDates(startDate: startDate, endDate: endDate) }
                DatePicker("To", selection: $endDate, displayedComponents: .date)
                    .onChange(of: endDate) { _ in viewModel.updateDates(startDate: startDate, endDate: endDate) }
            }
            .padding()

            if UIDevice.current.userInterfaceIdiom == .pad {
                Chart {
                    ForEach(viewModel.expensesByCategory, id: \.key) { category, total in
                        SectorMark(
                            angle: .value("Expenses", total),
                            innerRadius: .ratio(0.5),
                            outerRadius: .ratio(1.0)
                        )
                        .foregroundStyle(by: .value("Category", category))
                        .symbolSize(by: .value("Category", category))
                    }
                }
                .padding()
                .frame(height: 800)
            } else {
                Chart {
                    ForEach(viewModel.expensesByCategory, id: \.key) { category, total in
                        SectorMark(
                            angle: .value("Expenses", total),
                            innerRadius: .ratio(0.5),
                            outerRadius: .ratio(1.0)
                        )
                        .foregroundStyle(by: .value("Category", category))
                    }
                }
                .padding()
            }
            
            Spacer()
            // Totals
            VStack {
                Text("Total Income: \(viewModel.totalIncome, specifier: "%.2f") $")
                    .foregroundColor(.green)
                Text("Total Expenses: \(viewModel.totalExpenses, specifier: "%.2f") $")
                    .foregroundColor(.red)
            }
            if UIDevice.current.userInterfaceIdiom == .pad {
                Spacer()
            }
        }
        .padding()
        .onAppear {
            viewModel.updateDates(startDate: startDate, endDate: endDate)
        }
    }
}


