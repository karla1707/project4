//
//  Categorie.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 08.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation

struct Categorie: Codable, Identifiable {
    var id : String {
        return name
    }
    var name: String
}
