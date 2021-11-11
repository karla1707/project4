//
//  User.swift
//  G8ProductPriceAlert
//
//  Created by Fotios Alatas on 27.05.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    
    internal init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    
    
    var id: String{
        return email
    }
    let email: String
    let password: String
}
