//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Виктор on 17.06.2020.
//  Copyright © 2020 SwiftViktor. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: NewOrder
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.newOrderStruct.name)
                TextField("Street Address", text: $order.newOrderStruct.streetAddress)
                TextField("City", text: $order.newOrderStruct.city)
                TextField("Zip", text: $order.newOrderStruct.zip)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Check out")
                }
            }
            .disabled(!order.newOrderStruct.hasValidAddress)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: NewOrder())
    }
}
