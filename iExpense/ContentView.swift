//
//  ContentView.swift
//  iExpense
//
//  Created by Juan Carlos Robledo Morales on 18/09/24.
//

import SwiftUI
import Observation


@Observable
class User {
    var firstName = "Bilbo"
    var lastName = "Baggins"
}


struct ContentView: View {
    @State private var user = User()

    var body: some View {
        VStack {
            Text("Tu nombre es \(user.firstName) \(user.lastName).")

            TextField("Nombre", text: $user.firstName)
            TextField("Apellido", text: $user.lastName)
        }
    }
}

#Preview {
    ContentView()
}
