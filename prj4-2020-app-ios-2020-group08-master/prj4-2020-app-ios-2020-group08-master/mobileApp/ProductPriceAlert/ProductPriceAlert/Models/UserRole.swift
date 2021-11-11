//
//  UserRole.swift
//  G8ProductPriceAlert
//
//  Created by Fotios Alatas on 27.05.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation

struct UserRole: Codable, Identifiable, Equatable {
    
    internal init(id: Int, userid: String, roleid: String) {
        self.id = id
        self.userid = userid
        self.roleid = roleid
    }
    
    
    let id: Int
    let userid: String
    let roleid: String
}
