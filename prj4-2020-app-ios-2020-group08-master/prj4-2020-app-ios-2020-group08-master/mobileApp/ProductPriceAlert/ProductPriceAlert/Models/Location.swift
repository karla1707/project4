//
//  Location.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 08.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation


struct Location: Codable, Identifiable, Equatable {
    
    internal init(id: Int, street: String, postalCode: String, sNumber: String, city: String, country: String, longitude: String, latitude: String) {
        self.id = id
        self.street = street
        self.postalCode = postalCode
        self.sNumber = sNumber
        self.city = city
        self.country = country
        self.longitude = longitude
        self.latitude = latitude
    }
    
    
    var id: Int
    var street: String
    var postalCode : String
    var sNumber: String
    var city : String
    var country : String
    var longitude : String
    var latitude : String
    
    //Compare to method in Java :)
    public static func == (lhs: Location, rhs: Location) -> Bool {
        return
            lhs.street == rhs.street &&
                lhs.postalCode == rhs.postalCode &&
                lhs.country == rhs.country &&
                lhs.sNumber == rhs.sNumber &&
                lhs.city == rhs.city
        /*
         lhs.latitude == rhs.latitude &&
         lhs.longitude == rhs.longitude
         */
    }
}
