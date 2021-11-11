//
//  ContentView.swift
//  ProductPriceAlert
//
//  Created by Daniyal on 31/03/2020.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI

/// Modal view (sheet) properties
class ModalSheet: ObservableObject {
    @Published var show = false
    @Published var productId = "1"
}

struct ContentView: View {
    @EnvironmentObject var loginCustomerData : LoginCustomerData
    @EnvironmentObject var editCustomerData : EditCustomerData
    @EnvironmentObject var customerData : CustomerData
    @EnvironmentObject var modal: ModalSheet
    static var url = "https://price-alert-backend.eu-gb.mybluemix.net"

    var body: some View {
        TabBarView()
            .environmentObject(self.loginCustomerData).environmentObject(self.editCustomerData).environmentObject(self.customerData)
            // Fetch the product received from the notification payload and present it as modal view (sheet)
            .sheet(isPresented: $modal.show) {
            OneProductFetcher(pId: self.modal.productId)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
