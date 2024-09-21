//
//  ContentView.swift
//  iExpense
//
//  Created by Juan Carlos Robledo Morales on 18/09/24.
//


import SwiftUI

struct ExpenseItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

enum Currency: String, CaseIterable, Identifiable {
    case usd = "USD"
    case mxn = "MXN"

    var id: String { self.rawValue }
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    var personalItems: [ExpenseItem] {
        items.filter { $0.type == "Personal" }
    }
    
    var businessItems: [ExpenseItem] {
        items.filter { $0.type == "Business" }
    }

    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }

        items = []
    }

    func addItem(_ item: ExpenseItem) {
        items.append(item)
    }
}


struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    @State private var selectedCurrency: Currency = .usd
 
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
                    Section(header: Text("Personal Expenses")) {
                        ForEach(expenses.personalItems) { item in
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
                        .onDelete(perform: removePersonalItems)
                    }
                    
                    Section(header: Text("Business Expenses")) {
                        ForEach(expenses.businessItems) { item in
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
                        .onDelete(perform: removeBusinessItems)
                    }
                }
                .navigationTitle("iExpense")
                .toolbar {
                    Button {
                        showingAddExpense = true
                    } label: {
                        Label("Add Expense", systemImage: "plus")
                    }
                }
                .sheet(isPresented: $showingAddExpense) {
                    AddView(expenses: expenses, selectedCurrency: $selectedCurrency)
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
    
    func removePersonalItems(at offsets: IndexSet) {
        for offset in offsets {
            if let index = expenses.items.firstIndex(of: expenses.personalItems[offset]) {
                expenses.items.remove(at: index)
            }
        }
    }

    func removeBusinessItems(at offsets: IndexSet) {
        for offset in offsets {
            if let index = expenses.items.firstIndex(of: expenses.businessItems[offset]) {
                expenses.items.remove(at: index)
            }
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
}
