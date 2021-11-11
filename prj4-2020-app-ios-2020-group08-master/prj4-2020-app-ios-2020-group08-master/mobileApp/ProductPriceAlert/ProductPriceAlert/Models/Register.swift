//
//  Register.swift
//  G8ProductPriceAlert
//
//  Created by Fotios Alatas on 28.05.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation

//
//  RegisterModel.swift
//  G8ProductPriceAlert
//
//  Created by Fotios Alatas on 28.05.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation

struct Register: Codable, Identifiable, Equatable {
    
    internal init(firstName: String, lastName: String, email: String, password: String, locationId: Int, image: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.locationId = locationId
        self.image = image
    }
    
    
    var id: String{
        return email
    }
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var locationId : Int
    var image : String
    
    
    //Compare to method in Java :)
    public static func == (lhs: Register, rhs: Register) -> Bool {
        return
            lhs.email == rhs.email &&
                lhs.firstName == rhs.firstName &&
                lhs.lastName == rhs.lastName &&
                lhs.locationId == rhs.locationId &&
                lhs.image == rhs.image
    }
}
