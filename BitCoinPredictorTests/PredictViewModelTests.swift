//
//  PredictViewModelTests.swift
//  BitCoinPredictorTests
//
//  Created by Vincent Moyo on 2021/08/04.
//

import XCTest
@testable import BitCoinPredictor

class PredictViewModelTests: XCTestCase {
    
    var predictViewModel = PredictViewModel()
    
    func testPricesLoadTimeOnDatabase() {
        let waitingForCompletionException = expectation(description: "Waiting for database to load bitcoin prices")
        predictViewModel.loadPricesFromDatabase()
        predictViewModel.didPredictViewModelLoad = { result in
            if result {
                waitingForCompletionException.fulfill()
            }
        }
        wait(for: [waitingForCompletionException], timeout: 5)
    }
    
    func testBitcoinAPI() {
        let waitingForCompletionException = expectation(description: "Waiting for database to load retrieve bitcoin prices from prices")
        predictViewModel.bitcoinPrinceUsingAPI()
        predictViewModel.didPredictViewModelLoad = { result in
            if result {
                waitingForCompletionException.fulfill()
            }
        }
        wait(for: [waitingForCompletionException], timeout: 5)
    }
    
    func testBalancesLoadTimeOnDatabase() {
        let waitingForCompletionException = expectation(description: "Waiting for database to load balances")
        predictViewModel.loadBalancesFromDatabase()
        predictViewModel.didPredictViewModelLoad = { result in
            if result {
                waitingForCompletionException.fulfill()
            }
        }
        wait(for: [waitingForCompletionException], timeout: 5)
    }
}
