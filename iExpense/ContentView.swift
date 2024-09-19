//
//  ContentView.swift
//  iExpense
//
//  Created by Juan Carlos Robledo Morales on 18/09/24.
//

import SwiftUI

struct ExpenseItem: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
}


@Observable
class Expenses {
    var items = [ExpenseItem]()
}


struct ContentView: View {
    @State private var expenses = Expenses()

    @State private var showingAddExpense = false

    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    Text(item.name)
                }


                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense){
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}



#Preview {
    ContentView()
}
