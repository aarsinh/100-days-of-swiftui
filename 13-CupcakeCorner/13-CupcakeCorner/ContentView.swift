//
//  ContentView.swift
//  13-CupcakeCorner
//
//  Created by Aarav Sinha on 15/06/24.
//

import SwiftUI
import Observation

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequests = "specialRequests"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zip = "zip"
    }
    
    static let types = ["Vanilla", "Chocolate", "Strawberry", "Blueberry"]
    
    var type = 0
    var quantity = 1
    var specialRequests = false {
        didSet {
            if specialRequests == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
        
    var validAddress: Bool {
        for field in [name, streetAddress, city, zip] {
            if field.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
        }
        return true
    }
    
    var cost: Double {
        var cost = Double(quantity) * 100
        
        if extraFrosting {
            cost += 50 * Double(quantity)
        }
        
        if addSprinkles {
            cost += 25 * Double(quantity)
        }
        return cost
    }
    
    var images: [String] = [
        "https://www.allrecipes.com/thmb/i9KCEbxUGQ1Sa4F7Gts7SGBOpoM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/157877-vanilla-cupcakes-ddmfs-4X3-0397-59653731be1d4769969698e427d7f5bc.jpg",
        "https://www.allrecipes.com/thmb/riDYvmalWk8QgJDBT_pZRkpfpR0=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/17377-chocolate-cupcakes-DDMFS-4x3-622a7a66fcd84692947794ed385dc991.jpg",
        "https://www.foodandwine.com/thmb/aNXsLtfNGLNQP0hkCN9XZtleAGQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/strawberry-cupcakes-with-cream-cheese-frosting-FT-RECIPE0621-69e89be5ed9645b29a760d43c205bfae.jpg",
        "https://bubbapie.com/wp-content/uploads/2020/02/Lemon-Blueberry-Cupcakes.jpg"
    ]
}

struct ContentView: View {
    @State private var order = Order()
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of cupcakes: \(order.quantity)", value: $order.quantity, in: 1...20)
                }
                
                Section {
                    Toggle(isOn: $order.specialRequests, label: {
                        Text("Special Requests")
                    })
                    
                    if order.specialRequests {
                        Toggle(isOn: $order.extraFrosting, label: {
                            Text("Extra frosting")
                        })
                        
                        Toggle(isOn: $order.addSprinkles, label: {
                            Text("Add sprinkles")
                        })
                    }
                }
                
                Section {
                    NavigationLink("Delivery Details", destination: AddressView(order: order))
                }
            }
            .navigationTitle("Cupcake Corner")
        }
            
    }
}

#Preview {
    ContentView()
}
