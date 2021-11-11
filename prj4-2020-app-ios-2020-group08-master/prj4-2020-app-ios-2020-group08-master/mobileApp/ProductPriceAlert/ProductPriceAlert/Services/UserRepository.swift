//
//  UserRepository.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 05.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation
import SwiftUI

struct UserRepo {
    
    @ObservedObject var fetch : GenericFetchList<Location>
    
    init(fetch: GenericFetchList<Location>) {
        self.fetch = fetch
        
    }
    
    func checkIfValidUser(){
        let list = self.fetch.list
        for customer in list {
            print(customer.street)
        }
    }
    
    
}

