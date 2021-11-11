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

class GenericFetchListTest: XCTestCase {

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

    // Test HTTP Request GET for specified id
    func testLimit() {

        var fetch = GenericFetchList<Product>()
        fetch.requestSettings.limit = 10

        let predicate = NSPredicate(block: {(_,_) in
            print(fetch.list)
            return fetch.list.count == 10
        });
        self.expectation(for: predicate, evaluatedWith: fetch)

        fetch.reload()

        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5) {
            error in
            if let error = error {
                XCTFail("Error \(error)")
            }
        }
    }

    func testWhere() {

        var fetch = GenericFetchList<Product>()
        fetch.requestSettings.where = ["name" : WhereOptions(ilike: "%Hand%")]

        let predicate = NSPredicate(block: {(_,_) in
            print(fetch.list)
            print (fetch.list.map({p in p.name}))
            return fetch.list.count != 0 && fetch.list.allSatisfy({p in p.name.localizedCaseInsensitiveContains("Hand")})
        });
        self.expectation(for: predicate, evaluatedWith: fetch)

        fetch.reload()

        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5) {
            error in
            if let error = error {
                XCTFail("Error \(error)")
            }
        }
    }

}
