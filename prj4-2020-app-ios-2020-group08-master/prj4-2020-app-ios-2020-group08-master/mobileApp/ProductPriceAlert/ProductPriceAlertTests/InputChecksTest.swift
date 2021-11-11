//
//  InputChecksTest.swift
//  G8ProductPriceAlert
//
//  Created by Fotios Alatas on 05.06.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//


import Foundation
import XCTest
@testable import G8ProductPriceAlert


class InputChecksTest: XCTestCase {
    
    func testInputCheck(){
        //test input validation methods
        var testString = "hjcsjhhcs@"
        var bool = testString.TextFieldValidation(testString)
        XCTAssertFalse(bool)
        
        testString = "shfijsfkjsd"
        bool = testString.TextFieldValidation(testString)
        XCTAssertTrue(bool)
        
        //valid email
        testString = "fontys@venlo.org"
        bool = testString.EmailFieldValidation(testString)
        XCTAssertTrue(bool)
        //False email
        testString = "fontys!venlo.org"
        bool = testString.EmailFieldValidation(testString)
        XCTAssertFalse(bool)
        
        //only numbers and letters
        testString = "f1"
        bool = testString.TextWithNumbersOnly(testString)
        XCTAssertTrue(bool)
        
        //only numbers and letters
        testString = "ffffff12313£@£"
        bool = testString.TextWithNumbersOnly(testString)
        XCTAssertFalse(bool)
        
        //only numbers and letters
        testString = "ffffff12313£@£"
        bool = testString.PasswordValidation(testString)
        XCTAssertFalse(bool)
        
        //only numbers and letters
        testString = "fffwefwfw1123"
        bool = testString.PasswordValidation(testString)
        XCTAssertTrue(bool)
        
    }

}
