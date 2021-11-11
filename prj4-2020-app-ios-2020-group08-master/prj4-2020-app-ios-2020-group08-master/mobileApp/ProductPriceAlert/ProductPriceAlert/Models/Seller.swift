//
//  Seller.swift
//  SellerList
//
//  Created by Nils Bauroth on 04.04.20.
//  Copyright © 2020 Nils Bauroth. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Seller: Codable, Identifiable {

    var id: Int
    var name: String
    var locationId: Int
    var logo: String
    //var longitude: String
    //var latitude: String
}
