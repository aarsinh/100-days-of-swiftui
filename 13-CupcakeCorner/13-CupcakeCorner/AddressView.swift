//
//  AddressView.swift
//  13-CupcakeCorner
//
//  Created by Aarav Sinha on 17/06/24.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $order.name)
                    TextField("Street", text: $order.streetAddress)
                    TextField("City", text: $order.city)
                    TextField("Zip", text: $order.zip)
                }
                
                Section {
                    NavigationLink("Proceed to checkout", destination: CheckoutView(order: order))
                        .disabled(!order.validAddress)
                }
            }
            .onDisappear(perform: {
                if let encoded = try? JSONEncoder().encode(order) {
                    UserDefaults.standard.set(encoded, forKey: "order")
                }
            })
            .navigationBarTitle("Delivery Details", displayMode: .inline)
            .onAppear(perform: {
                if let saved = UserDefaults.standard.data(forKey: "order") {
                    if let decoded = try? JSONDecoder().decode(Order.self, from: saved) {
                        self.order.name = decoded.name
                        self.order.streetAddress = decoded.streetAddress
                        self.order.city = decoded.city
                        self.order.zip = decoded.zip
                    }
                }
            })
        }
    }
}

#Preview {
    AddressView(order: Order())
}
