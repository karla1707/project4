//
// Created by Paul Severin on 07.05.20.
// Copyright (c) 2020 Fontys UAS. All rights reserved.
//

import Foundation

struct Alert: Codable, Identifiable {

    var id: Int
    var customerEmail : String
    var productId : Int
    var maxPrice : Int
}