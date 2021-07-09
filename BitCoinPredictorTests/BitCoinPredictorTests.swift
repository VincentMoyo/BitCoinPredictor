//
//  BitCoinPredictorTests.swift
//  BitCoinPredictorTests
//
//  Created by Vincent Moyo on 2021/07/01.
//

import XCTest
@testable import BitCoinPredictor

class BitCoinPredictorTests: XCTestCase {

    let crementvalues = CrementClass()
        
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testNegativeIncrementValue() {
        let negIncrement = crementvalues.incrementByInterval(50000, -1, true)
        XCTAssertEqual(negIncrement, 0.0)
    }

    func testPerformanceExample() throws {

        self.measure {

        }
    }

}
