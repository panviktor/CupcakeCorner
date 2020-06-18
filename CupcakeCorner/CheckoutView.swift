//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Виктор on 17.06.2020.
//  Copyright © 2020 SwiftViktor. All rights reserved.
//

import SwiftUI
import Network

struct CheckoutView: View {
    @ObservedObject var order: NewOrder
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var showingAlert = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    
                    Text("Your total is $\(self.order.newOrderStruct.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place Order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func placeOrder() {
        guard let encoded  = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        guard checkInternetConnectionMonitor() else {
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(NewOrder.self, from: data) {
                self.alertMessage = "Your order for \(decodedOrder.newOrderStruct.quantity)x \(NewOrderStruct.types[decodedOrder.newOrderStruct.type].lowercased()) cupcakes is on its way!"
                self.alertTitle = "Thank you!"
                self.showingAlert = true
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: NewOrder())
    }
}


extension CheckoutView {
    func checkInternetConnectionMonitor() -> Bool {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                self.alertMessage = "Check your Internet access and try again!"
                self.alertTitle = "No connection!"
                self.showingAlert = true
                print("No connection.")
            }
        }
        return true
    }
}
