//
//  EditCustomerData.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 14.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation
import SwiftUI

/*
 Similar to the login one but it is used when editing the views
 */

class EditCustomerData: ObservableObject {
    @Published var editEmail = ""

    @Published var email = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var password = ""
    @Published var locId = 0
    @Published var street = ""
    @Published var sNumber = ""
    @Published var postalCode = ""
    @Published var country = ""
    @Published var city = ""
    @Published var long = 0.0
    @Published var lat = 0.0
    @Published var image = UIImage()
    @Published var userMessage = ""
    @Published var img = ""

    
    func reset() {
        self.editEmail = ""
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.street = ""
        self.sNumber = ""
        self.postalCode = ""
        self.country = ""
        self.city = ""
        self.lat = 0.0
        self.long = 0.0
        self.userMessage = ""
        if let image = UIImage(systemName: "person") {
            self.image = image
        }
        
    }
}
