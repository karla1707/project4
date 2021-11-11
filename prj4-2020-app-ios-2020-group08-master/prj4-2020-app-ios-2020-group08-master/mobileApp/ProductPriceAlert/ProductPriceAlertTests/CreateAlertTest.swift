//
//  GenericFetchListTest.swift
//  G8ProductPriceAlertTests
//
//  Created by Paul Severin on 04.06.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import XCTest
import Foundation
@testable import G8ProductPriceAlert

class CreateAlertTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testPriceValidation() throws {
        XCTAssert(toCents("") == nil)
        XCTAssert(toCents("1") == 100)
        XCTAssert(toCents("500") == 50000)
        XCTAssert(toCents("500.0") == 50000)
        XCTAssert(toCents("-34") == nil)
        XCTAssert(toCents("0") == nil)
        XCTAssert(toCents("asdv") == nil)
    }


}