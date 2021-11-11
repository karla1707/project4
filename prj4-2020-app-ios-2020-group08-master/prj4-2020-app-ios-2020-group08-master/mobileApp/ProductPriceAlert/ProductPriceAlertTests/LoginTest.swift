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

class LoginTest: XCTestCase {

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

    func testLogin() throws {
        let exp = expectation(description: "wait")

        let postman = EntityPostMan()
        let user = User(email: "ojacqueminet0@deliciousdays.com", password: "password")
        let userData = try JSONSerialization.data(withJSONObject: postman.getEntityDictionary(entity: user), options: .init())
        postman.login(request: userData, resultType : User.self) { data in
            print(data)
            XCTAssert(data.email == user.email)
            XCTAssert(data.roles == ["Customer"])
            XCTAssert(data.token != "")
            exp.fulfill()
        }

        waitForExpectations(timeout: 5) {
            error in
            if let error = error {
                XCTFail("Error \(error)")
            }
        }
    }


}