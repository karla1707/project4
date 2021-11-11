//
// Created by Paul Severin on 04.06.20.
// Copyright (c) 2020 Fontys UAS. All rights reserved.
//

import Foundation

class LoginResponse : Codable {
    var token : String
    var email : String
    var roles : [String]
}
