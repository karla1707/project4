//
// Created by Paul Severin on 23.04.20.
// Copyright (c) 2020 Fontys UAS. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct CreatePriceAlert: View {

    @State private var priceString: String = ""
    @State private var loginPopup = false
    @State private var newAlertPopup = false
    @EnvironmentObject var loginCustomerData: LoginCustomerData
    var product: Product

    init(product: Product) {
        self.product = product
    }

    private var cents: Int? {
        toCents(priceString)
    }

    var buttonColor: Color {
        return cents == nil ? .gray : .green
    }

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>


    var body: some View {
        VStack() {
            TextField("Price", text: $priceString)
                .padding(7)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color.black, lineWidth: 1)
                )
                .keyboardType(.numberPad)
                .padding(.all)
                .frame(width: 120)
                .foregroundColor(Color.black)
                .alert(isPresented: $newAlertPopup) {
                    SwiftUI.Alert(title: Text("Alert created!"), message: Text(""), dismissButton: .default(Text("OK"), action: { () in self.presentationMode.wrappedValue.dismiss() }))
                }


            Button(action: submit) {
                Text("Create")
            }
                .padding(.all)
                .cornerRadius(10.0)
                .foregroundColor(buttonColor)
                .disabled(self.cents == nil)
                .alert(isPresented: $loginPopup) {
                    SwiftUI.Alert(title: Text("Please login!"), message: Text(""), dismissButton: .default(Text("OK"), action: { () in self.presentationMode.wrappedValue.dismiss() }))
                }

        }
    }

    func submit() {
        print(loginCustomerData);
        if (loginCustomerData.token.isEmpty) {
            loginPopup = true;
            return
        }
    var components = URLComponents(string: ContentView.url + "/alerts")!
        //var components = URLComponents(string: "http://[::1]:3000/alerts")!

        let access_token = loginCustomerData.token
        let email = loginCustomerData.email

        components.queryItems = [URLQueryItem(name: "access_token", value: access_token)]

        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = "POST"

        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(NewAlert(customerEmail: email, productId: product.id, maxPrice: cents!));

            urlRequest.httpBody = data
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

            URLSession.shared.dataTask(with: urlRequest) { (optionalData, response, error) in
                do {
                    print(response)
                    self.newAlertPopup = true
                } catch {
                    print("Error: \(error)")
                }
            }.resume()
        } catch {
        }
    }
}

// validate price input string and convert to cents
func toCents(_ str: String) -> Int? {
    Double(str.replacingOccurrences(of: ",", with: "."))
        .map {
            Int(($0) * 100)
        }
        .flatMap {
            ($0) > 0 ? ($0) : nil
        }
}