//
//  BalanceViewModelTests.swift
//  BitCoinPredictorTests
//
//  Created by Vincent Moyo on 2021/08/04.
//

import XCTest
@testable import BitCoinPredictor

class BalanceViewModelTests: XCTestCase {
    
    var balanceViewModel = BalanceViewModel()
    
    func testBalancesLoadTimeOnDatabase() {
        let waitingForCompletionException = expectation(description: "Waiting for database to load balances")
        balanceViewModel.loadBalancesFromDatabase()
        balanceViewModel.didBalanceViewModelLoad = { result in
            if result {
                waitingForCompletionException.fulfill()
            }
        }
        wait(for: [waitingForCompletionException], timeout: 5)
    }
    
    func testPredictedPricesLoadTimeOnDatabase() {
        let waitingForCompletionException = expectation(description: "Waiting for database to load predicted prices")
        balanceViewModel.loadPredictedPricesFromDatabase()
        balanceViewModel.didBalanceViewModelLoad = { result in
            if result {
                waitingForCompletionException.fulfill()
            }
        }
        wait(for: [waitingForCompletionException], timeout: 5)
    }
    
}
