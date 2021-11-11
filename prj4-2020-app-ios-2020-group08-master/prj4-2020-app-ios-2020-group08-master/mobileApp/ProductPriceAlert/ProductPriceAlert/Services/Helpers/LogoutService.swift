//
//  LogoutService.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 15.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation

class LogoutService {
    
    /*
     Sets all the env used variables to "" or 0
     */
    func logout(loginData: LoginCustomerData, registerData: CustomerData, editData: EditCustomerData){
        loginData.reset()
        registerData.reset()
        editData.reset()
    }
    
    //Uses reflection to prin all the values from the env variables
    func debugLogout<Entity: ObservableObject>(entity: Entity){
        let reflection = Mirror(reflecting: entity)
        
        for (name, value) in reflection.children {
            guard let name = name else { continue }
            print(" '\(value)'")
        }
    }
    
}
