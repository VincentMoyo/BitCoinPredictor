//
//  ComparisonViewModelTests.swift
//  BitCoinPredictorTests
//
//  Created by Vincent Moyo on 2021/08/04.
//

import XCTest
@testable import BitCoinPredictor

class ComparisonViewModelTests: XCTestCase {
    
    var comparisonViewModel = ComparisonViewModel()
    
    func testNegativeCheckBitCoin() {
        let bitcoin = comparisonViewModel.checkBitcoin(-1.0, 1000000.0)
        XCTAssertEqual(bitcoin, 0.0)
    }
    
    func testPricesLoadTimeOnDatabase() {
        let waitingForCompletionException = expectation(description: "Waiting for database to load bitcoin prices")
        comparisonViewModel.loadPricesFromDatabase()
        comparisonViewModel.didComparisonViewModelLoad = { result in
            if result {
                waitingForCompletionException.fulfill()
            }
        }
        wait(for: [waitingForCompletionException], timeout: 5)
    }
    
    func testPredictedPricesLoadTimeOnDatabase() {
        let waitingForCompletionException = expectation(description: "Waiting for database to load predicted prices")
        comparisonViewModel.loadPredictedPricesFromDatabase()
        comparisonViewModel.didComparisonViewModelLoad = { result in
            if result {
                waitingForCompletionException.fulfill()
            }
        }
        wait(for: [waitingForCompletionException], timeout: 5)
    }
    
    func testBalancesLoadTimeOnDatabase() {
        let waitingForCompletionException = expectation(description: "Waiting for database to load balances")
        comparisonViewModel.loadBalancesFromDatabase()
        comparisonViewModel.didComparisonViewModelLoad = { result in
            if result {
                waitingForCompletionException.fulfill()
            }
        }
        wait(for: [waitingForCompletionException], timeout: 5)
    }
}
