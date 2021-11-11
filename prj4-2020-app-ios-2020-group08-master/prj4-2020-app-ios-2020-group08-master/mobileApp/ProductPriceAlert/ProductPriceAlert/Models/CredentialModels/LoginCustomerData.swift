//
//  LoginCustomerData.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 06.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation
import SwiftUI

/*
 This class is used to save the values of the logged in user in order to share them among the various views
 */

class LoginCustomerData: ObservableObject {
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
    @Published var isOnEdit = false
    @Published var emptyValue = ""
    @Published var userMessage = ""
    @Published var img = ""
    @Published var token = ""
    
    func reset() {
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.password = ""
        self.street = ""
        self.sNumber = ""
        self.postalCode = ""
        self.country = ""
        self.city = ""
        self.isOnEdit = false
        self.lat = 0.0
        self.long = 0.0
        self.userMessage = ""
        self.token = ""
        if let image = UIImage(systemName: "person") {
            self.image = image
        }
        
    }
}
