//
//  Customer.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 05.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation

struct Customer: Codable, Identifiable, Equatable {
    
    internal init(firstName: String, lastName: String, email: String, locationId: Int, image: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.locationId = locationId
        self.image = image
    }
    
    
    var id: String{
        return email
    }
    var firstName: String
    var lastName: String
    var email: String
    var locationId : Int
    var image : String
    
    //Compare to method in Java :)
    public static func == (lhs: Customer, rhs: Customer) -> Bool {
        return
            lhs.email == rhs.email &&
                lhs.firstName == rhs.firstName &&
                lhs.lastName == rhs.lastName &&
                lhs.locationId == rhs.locationId &&
                lhs.image == rhs.image
    }
}
