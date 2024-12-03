//
//  TransactionRow.swift
//  MyFananceTracker
//
//  Created by Vitya Mandryk on 27.11.2024.
//

import Foundation
import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.category)
                    .font(.headline)
                Text(transaction.date, style: .date)
                    .font(.subheadline)
            }
            Spacer()
            Text("\(transaction.amount, specifier: "%.2f") $")
                .foregroundColor(transaction.type == .income ? .green : .red)
        }
    }
}
