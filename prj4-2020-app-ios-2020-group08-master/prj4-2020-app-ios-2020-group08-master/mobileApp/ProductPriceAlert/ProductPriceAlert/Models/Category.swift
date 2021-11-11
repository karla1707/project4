//
//  Category.swift
//  G8ProductPriceAlert
//
//  Created by Karla on 23/04/2020.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

struct Category : Codable, Hashable{
    var name : String
   
    enum CodingKeys: String, CodingKey {
        case name = "name"
       
    }
}
  
// Now conform to Identifiable
extension Category : Identifiable {
    var id : String { return name }
}
