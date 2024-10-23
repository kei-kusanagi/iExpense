//
//  ContentView.swift
//  iExpense
//
//  Created by Juan Carlos Robledo Morales on 18/09/24.
//

import SwiftData
import SwiftUI

@Model
class ExpenseItem {
    let name: String
    let type: String
    let amount: Double
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}

enum Currency: String, CaseIterable, Identifiable {
    case usd = "USD"
    case mxn = "MXN"

    var id: String { self.rawValue }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var expenses: [ExpenseItem]
    @State private var showingAddExpense = false
    @State private var selectedCurrency: Currency = .usd
    

    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount)
    ]
 
    var sortedExpenses: [ExpenseItem] {

        expenses.sorted(using: sortOrder)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Currency", selection: $selectedCurrency) {
                    ForEach(Currency.allCases) { currency in
                        Text(currency.rawValue).tag(currency)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    Section(header: Text("Expenses")) {
                        ForEach(sortedExpenses) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }
                                
                                Spacer()
                                Text(formatPrice(item.amount, in: selectedCurrency))
                                    .applyStyle(for: item.amount)
                            }
                        }
                        .onDelete(perform: removeItems)
                    }
                }
                .navigationTitle("iExpense")
                .toolbar {
                    NavigationLink(destination: AddView(selectedCurrency: $selectedCurrency)) {
                        Label("Add Expense", systemImage: "plus")
                    }
                }
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Button("Name (A-Z)") {
                        sortOrder = [
                            SortDescriptor(\ExpenseItem.name),
                            SortDescriptor(\ExpenseItem.amount)
                        ]
                    }
                    Button("Name (Z-A)") {
                        sortOrder = [
                            SortDescriptor(\ExpenseItem.name, order: .reverse),
                            SortDescriptor(\ExpenseItem.amount)
                        ]
                    }
                    Button("Cheapest First") {
                        sortOrder = [
                            SortDescriptor(\ExpenseItem.amount),
                            SortDescriptor(\ExpenseItem.name)
                        ]
                    }
                    Button("Most Expensive First") {
                        sortOrder = [
                            SortDescriptor(\ExpenseItem.amount, order: .reverse),
                            SortDescriptor(\ExpenseItem.name)
                        ]
                    }
                }
            }
        }
    }

    func formatPrice(_ amount: Double, in currency: Currency) -> String {
        switch currency {
        case .usd:
            return amount.formatted(.currency(code: "USD"))
        case .mxn:
            let convertedAmount = amount * 17.0
            return convertedAmount.formatted(.currency(code: "MXN"))
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        for offset in offsets {
            let item = expenses[offset]
            modelContext.delete(item)
        }
    }
}

extension View {
    func applyStyle(for amount: Double) -> some View {
        if amount < 10 {
            return self.foregroundColor(.green)
                .font(.body.bold())
        } else if amount < 100 {
            return self.foregroundColor(.orange)
                .font(.body)
        } else {
            return self.foregroundColor(.red)
                .font(.headline)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseItem.self)
}
