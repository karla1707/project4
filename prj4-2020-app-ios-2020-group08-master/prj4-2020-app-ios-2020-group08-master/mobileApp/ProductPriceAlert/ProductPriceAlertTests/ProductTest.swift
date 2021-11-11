//
//  GenericFetchListTest.swift
//  G8ProductPriceAlertTests
//
//  Created by Paul Severin on 04.06.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import XCTest
@testable import G8ProductPriceAlert

class ProductTest: XCTestCase {

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
    func testProductGet() {

        // 1. Define an expectation
        let expect = expectation(description: "Request and run callback closure")

        // 2. Define session and url
        let defaultSession = URLSession(configuration: .default)
        let url = URL(string: ContentView.url + "/products/1")

        // 3. Define the task
        // Forced unwrap of url - we set it ourselves
        let task = defaultSession.dataTask(with: url!) { data, response, error in
            // Check data
            if let data = data  {
                // Decode JSON
                let decoder = JSONDecoder()
                do {
                    let product = try decoder.decode(Product.self, from: data)
                    XCTAssert(product.id == 1, "Wrong product id")
                    XCTAssert(product.name == "Tetracycline Hydrochloride", "Wrong name")
                    XCTAssert(product.categoryName == "Adventure|Drama|Romance", "Wrong category")
                } catch {
                    XCTFail(error.localizedDescription)
                }

            } else {
                XCTFail("No data")
            }

            // 4. Don't forget to fulfill the expectation in the async callback
            expect.fulfill()

        }
        // 5. Run the tast
        task.resume()


        // 6. Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 4) {
            error in if let error = error {
                XCTFail("Error \(error)")
            }
        }
    }

}
