//
//  InputChecks.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 06.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation

extension String {
    //Checks for name and lastname
    func TextFieldValidation(_ input:String) -> Bool {
        let regex = "[a-zA-Z]{2,30}"
        
        let testString =  NSPredicate(format: "SELF MATCHES %@",  regex)
        
        return testString.evaluate(with: input)
    }
    
    func TextWithNumbersOnly(_ input:String) -> Bool {
        let regex = "^[a-zA-Z0-9]+$"
        let testString = NSPredicate(format:"SELF MATCHES %@", regex)
        return testString.evaluate(with: input)
    }
    
    func PasswordValidation(_ input:String) -> Bool {
        let regex = "^[a-zA-Z0-9]+$"
        
        let testString =  NSPredicate(format: "SELF MATCHES %@",  regex)
        
        return testString.evaluate(with: input)
    }
    
    func EmailFieldValidation(_ input:String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let testString =  NSPredicate(format: "SELF MATCHES %@",  regex)
        
        return testString.evaluate(with: input)
    }
}

