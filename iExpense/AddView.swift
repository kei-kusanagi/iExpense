//
//  AddView.swift
//  iExpense
//
//  Created by Juan Carlos Robledo Morales on 19/09/24.
//

import SwiftUI

struct AddView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = "New Expense"
    @State private var type = "Personal"
    @State private var amount = 0.0

    let types = ["Business", "Personal"]
    @Binding var selectedCurrency: Currency

    var body: some View {
        NavigationStack {
            Form {
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: selectedCurrency.rawValue))
                .keyboardType(.decimalPad)
            }
            .navigationTitle($name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar{
                Button("Save") {
                                    let finalAmount: Double
                                    if selectedCurrency == .mxn {
                                        finalAmount = amount / 17.0
                                    } else {
                                        finalAmount = amount
                                    }

                                    let item = ExpenseItem(name: name, type: type, amount: finalAmount)
                                    modelContext.insert(item)
                                    dismiss()
                                }
                Button("Cancel") {
                                    dismiss()
                                }
            }
        }
    }
}

#Preview {
    AddView(selectedCurrency: .constant(.usd))
        .modelContainer(for: ExpenseItem.self)
}
