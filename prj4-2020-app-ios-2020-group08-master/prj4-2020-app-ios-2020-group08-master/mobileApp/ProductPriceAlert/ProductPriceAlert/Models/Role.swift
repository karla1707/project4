//
//  Role.swift
//  G8ProductPriceAlert
//
//  Created by Fotios Alatas on 27.05.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation

struct Role: Codable, Identifiable, Equatable {
    
    var id: String{
        return name
    }
    let name: String
}
