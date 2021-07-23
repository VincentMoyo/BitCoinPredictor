//
//  BitCoinPredictorTests.swift
//  BitCoinPredictorTests
//
//  Created by Vincent Moyo on 2021/07/01.
//

import XCTest
@testable import BitCoinPredictor

class BitCoinPredictorTests: XCTestCase {

    let predictViewModel = PredictViewModel()
    let comparisonViewModel = ComparisonViewModel()
    let homeViewModel = HomeViewModel()
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testNegativeIncrementValue() {
        let negIncrement = predictViewModel.incrementByInterval(50000, -1, true)
        XCTAssertEqual(negIncrement, 0.0)
    }
    
    func testIfDatabseLoadsProperly() {
        var priceList: [PriceListModel] = []
        homeViewModel.loadPricesFromDatabse()
        priceList = homeViewModel.priceList
        XCTAssert(priceList.isEmpty)
    }
    
    func testPerformanceExample() throws {
        self.measure {

        }
    }
}
