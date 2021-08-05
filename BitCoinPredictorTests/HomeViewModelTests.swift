//
//  HomeViewModelTests.swift
//  BitCoinPredictorTests
//
//  Created by Vincent Moyo on 2021/08/04.
//

import XCTest
@testable import BitCoinPredictor

class HomeViewModelTests: XCTestCase {
    
    var homeViewModel = HomeViewModel()
    
    func testBitcoinAPI() {
        let waitingForCompletionException = expectation(description: "Waiting for database to load prices from Firebase")
        homeViewModel.bitcoinPriceUsingAPI()
        homeViewModel.didHomeViewModelLoad = { result in
            if result {
                waitingForCompletionException.fulfill()
            }
        }
        wait(for: [waitingForCompletionException], timeout: 5)
    }
    
    func testPricesLoadTimeOnDatabase() {
        let waitingForCompletionException = expectation(description: "Waiting for database to load bitcoin prices")
        homeViewModel.loadPricesFromDatabase()
        homeViewModel.didHomeViewModelLoad = { result in
            if result {
                waitingForCompletionException.fulfill()
            }
        }
        wait(for: [waitingForCompletionException], timeout: 10)
    }
}
