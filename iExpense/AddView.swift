//
//  AddView.swift
//  iExpense
//
//  Created by Juan Carlos Robledo Morales on 19/09/24.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0

    var expenses: Expenses
    let types = ["Business", "Personal"]
    @Binding var selectedCurrency: Currency

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)

                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }

                TextField("Amount", value: $amount, format: .currency(code: selectedCurrency.rawValue))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar{
                Button("Save"){
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.addItem(item)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses(), selectedCurrency: .constant(.usd))
}
