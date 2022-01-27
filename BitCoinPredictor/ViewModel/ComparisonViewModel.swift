//
//  ComparisonViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/20.
//

import Foundation
import FirebaseFirestore

class ComparisonViewModel {
    
    private let apiClass = BitcoinAPI()
    private var database = DatabaseManager(databaseReference: Firestore.firestore())
    var balanceData = BalanceData()
    private lazy var timerSeconds = 0
    lazy var predictedPrice = 0.0
    lazy var predictedTime = 0.0
    var previousPrice = 570000.12
    var priceArray: [PriceArrayModel] = []
    var priceData = PriceData()
    var predictedPriceData = PredictedPriceData()
    var counter = 0
    var didComparisonViewModelLoad: ((Bool) -> Void)?
    var comparisonViewModelError: ((Error) -> Void)?
    
    func updateTimer() {
        if timerSeconds % 5 == 0 && counter < 20 {
            timerSeconds += 1
            counter += 1
            loadPricesFromDatabase()
            loadPredictedPricesFromDatabase()
            checkEquity()
        } else {
            timerSeconds += 1
        }
    }
    
    func checkBitcoin (_ bitcoinPrice: Double, _ balance: Double) -> Double {
        bitcoinPrice <= 0 ? 0.0 : round((balance/bitcoinPrice)*100) / 100
    }
    
    private func checkEquity() {
        loadBalancesFromDatabase()
        let newCount = priceArray.count
        if let lastPrice = priceArray.last {
            if Double(newCount) < predictedPriceData.currentDate {
                balanceData.equity = balanceData.balance + Double(lastPrice.rate)!
                balanceData.freeMargin = balanceData.equity - Double(lastPrice.rate)!
                insertIntoBalanceDatabase()
            } else if Double(newCount) == predictedPriceData.currentDate {
                balanceData.balance += Double(lastPrice.rate)!
                balanceData.equity = balanceData.balance
                balanceData.freeMargin = balanceData.equity - Double(lastPrice.rate)!
                insertIntoBalanceDatabase()
            } else {
                insertIntoBalanceDatabase()
            }
        }
    }
    
    private func insertIntoBalanceDatabase() {
        database.updateAccountBalance(String(balanceData.balance),
                                            String(balanceData.equity),
                                            String(balanceData.freeMargin),
                                            String(checkBitcoin(priceData.price, balanceData.balance)))
    }
    
    func loadBalancesFromDatabase() {
        database.loadBalances { result in
            do {
                let newList = try result.get()
                newList.forEach { accountBalance in
                    self.balanceData.balance = Double(accountBalance.balance)!
                    self.balanceData.equity = Double(accountBalance.equity)!
                    self.balanceData.freeMargin = Double(accountBalance.freeMargin)!
                    self.balanceData.bitcoin = Double(accountBalance.bitcoin)!
                }
                self.didComparisonViewModelLoad?(true)
            } catch {
                self.comparisonViewModelError?(error)
            }
        }
    }
    
    func loadPredictedPricesFromDatabase() {
        database.loadPredictedPrice { result in
            do {
                let newPredictedPrice = try result.get()
                self.predictedPriceData.currentPrice = Double(newPredictedPrice.price)!
                self.predictedPriceData.currentDate = Double(newPredictedPrice.date)!
                self.didComparisonViewModelLoad?(true)
            } catch {
                self.comparisonViewModelError?(error)
            }
        }
    }
    
    func loadPricesFromDatabase() {
        database.loadPrices { result in
            do {
                let newList = try result.get()
                self.priceArray = newList
                let newPrice = newList.last
                self.priceData.price = Double(newPrice!.rate)!
                self.didComparisonViewModelLoad?(true)
            } catch {
                self.comparisonViewModelError?(error)
            }
        }
    }
}
