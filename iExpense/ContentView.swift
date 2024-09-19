//
//  ContentView.swift
//  iExpense
//
//  Created by Juan Carlos Robledo Morales on 18/09/24.
//

import SwiftUI


struct User: Codable {
    let firstName: String
    let lastName: String
}


struct ContentView: View {
    @State private var user = User(firstName: "Taylor", lastName: "Swift")

    @AppStorage("tapCount") private var tapCount = 0

    var body: some View {
        Button("Guardar usuario") {
            let encoder = JSONEncoder()

            if let data = try? encoder.encode(user) {
                UserDefaults.standard.set(data, forKey: "UserData")
            }
        }

    }
}


#Preview {
    ContentView()
}
