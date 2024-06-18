//
//  CheckoutView.swift
//  13-CupcakeCorner
//
//  Created by Aarav Sinha on 17/06/24.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    @State private var errorMessage = ""
    @State private var orderFailed = false
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    AsyncImage(url: URL(string: order.images[order.type]), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 20))
                    }  placeholder: {
                        ProgressView()
                    }
                    .frame(width: 300, height: 300)
                    
                    Text("Your total is \(order.cost, format: .currency(code: Locale.current.currency?.identifier ?? "INR"))")
                        .font(.headline)
                    
                    Button("Place order") {
                        Task {
                            await placeOrder()
                        }
                    }
                    .padding()
                }
                .navigationBarTitle("Check out", displayMode: .inline)
                .alert("Thank you!", isPresented: $showingConfirmation) {
                    Button("OK") { }
                } message: {
                    Text(confirmationMessage)
                }
                .alert("Order failed", isPresented: $orderFailed) {
                    Button("OK") { }
                } message: {
                    Text(errorMessage)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            errorMessage = "Order could not be placed. Check your internet connection and try again."
            orderFailed = true
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decoded = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decoded.quantity) x \(Order.types[decoded.type]) is on its way!"
            showingConfirmation = true
        } catch {
            errorMessage = "Order could not be placed. Check your internet connection and try again."
            orderFailed = true
            print("Checkout failed: \(error.localizedDescription)")
        }
        
        
    }
}

#Preview {
    CheckoutView(order: Order())
}
