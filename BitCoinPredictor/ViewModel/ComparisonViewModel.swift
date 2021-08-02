//
//  ComparisonViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/20.
//

import Foundation

class ComparisonViewModel {
    
    private let apiClass = BitcoinAPI()
    private let database = DatabaseManager()
    var balanceData = BalanceData()
    private lazy var timerSeconds = 0
    lazy var predictedPrice = 0.0
    lazy var predictedTime = 0.0
    var previousPrice = 600000.12
    var priceList: [PriceListModel] = []
    var priceData = PriceData()
    var predictedPriceData = PredictedPriceData()
    var didComparisonViewModelLoad: ((Bool) -> Void)?
    var comparisonViewModelError: ((Error) -> Void)?
    
    func updateTimer() {
        if timerSeconds % 5 == 0 {
            timerSeconds += 1
            bitcoinPriceUsingAPI()
            loadPricesFromDatabase()
            loadPredictedPricesFromDatabase()
            checkEquity()
        } else {
            timerSeconds += 1
        }
    }
    
    private func checkBitcoin (_ bitcoinPrice: Double, _ balance: Double) -> Double {
        return round((balance/bitcoinPrice)*100) / 100
    }
    
    private func checkEquity() {
        loadBalancesFromDatabase()
        let newCount = priceList.count
        if let lastPrice = priceList.last {
            if Double(newCount) < predictedPriceData.currentDate {
                balanceData.equity = balanceData.balance + Double(lastPrice.rate)!
                insertIntoBalanceDatabase()
            } else if Double(newCount) == predictedPriceData.currentDate {
                balanceData.balance += Double(lastPrice.rate)!
                balanceData.equity = balanceData.balance
                insertIntoBalanceDatabase()
            } else {
                insertIntoBalanceDatabase()
            }
        }
    }
    
    private func insertIntoBalanceDatabase() {
        database.updateAccountBalceDatabase(String(balanceData.balance),
                                            String(balanceData.equity),
                                            String(balanceData.freeMargin),
                                            String(checkBitcoin(priceData.price, balanceData.balance)))
    }
    
    private func loadBalancesFromDatabase() {
        database.loadBalanceFromDatabase { result in
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
    
    private func bitcoinPriceUsingAPI() {
        apiClass.getAPI { result in
            do {
                let newPrice = try result.get()
                self.database.insertPriceToDatabase(newPrice)
                self.priceData.price = Double(newPrice)!
                self.didComparisonViewModelLoad?(true)
            } catch {
                self.comparisonViewModelError?(error)
            }
        }
    }
    
    private func loadPredictedPricesFromDatabase() {
        database.loadPredictedPriceFromDatabase { result in
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
    
    private func loadPricesFromDatabase() {
        database.loadPricesFromDatabase { result in
            do {
                let newList = try result.get()
                self.priceList = newList
                self.didComparisonViewModelLoad?(true)
            } catch {
                self.comparisonViewModelError?(error)
            }
        }
    }
}
