//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Виктор on 16.06.2020.
//  Copyright © 2020 SwiftViktor. All rights reserved.
//

import SwiftUI
import Network

//MARK: - Main Code
struct ContentView: View {
    @ObservedObject var order = NewOrder()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select you cake type", selection:  $order.newOrderStruct.type) {
                        ForEach(0..<NewOrderStruct.types.count, id: \.self) {
                            Text(NewOrderStruct.types[$0])
                        }
                    }
                    
                    Stepper(value: $order.newOrderStruct.quantity, in: 3...20) {
                        Text("Number of cakes: \(order.newOrderStruct.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $order.newOrderStruct.specialRequestEnabled.animation()) {
                        Text("Any special request?")
                    }
                    
                    if order.newOrderStruct.specialRequestEnabled {
                        Toggle(isOn: $order.newOrderStruct.extraFrosting) {
                            Text("Add extra frosting")
                        }
                        
                        Toggle(isOn: $order.newOrderStruct.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: AddressView(order: order)) {
                        Text("Delivery details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
