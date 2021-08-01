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
    var priceList: [PriceListModel] = []
    var priceData = PriceData()
    var predictedPriceData = PredictedPriceData()
    var didComparisonViewModelLoad: ((Bool) -> Void)?
    var comparisonViewModelError: ((Error) -> Void)?
    
    func updateTimer() {
        if timerSeconds % 5 == 0 {
            timerSeconds += 1
            getBitcoinPrincUsingAPI()
            loadPricesFromDatabse()
            loadPredictedPricesFromDatabse()
            checkEquity()
        } else {
            timerSeconds += 1
        }
    }
    
    private func checkBitcoin (_ bitcoinPrice: Double, _ balance: Double) -> Double {
        return round((balance/bitcoinPrice)*100) / 100
    }
    
    private func checkEquity() {
        loadBalancesFromDatabse()
        
        let newCount = priceList.count
        if let lastPrice = priceList.last {
            if Double(newCount) < predictedPriceData.currentDate {
                balanceData.equity =  balanceData.balance + Double(lastPrice.rate)!
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
    
    private func loadBalancesFromDatabse() {
        database.loadBalanceFromDatabase { result in
            do {
                let newList = try result.get()
                newList.forEach { accountBalance in
                    self.balanceData.balance = Double(accountBalance.balance)!
                    self.balanceData.equity = Double(accountBalance.equity)!
                    self.balanceData.freeMargin = Double(accountBalance.freemargin)!
                    self.balanceData.bitcoin = Double(accountBalance.bitcoin)!
                }
                self.didComparisonViewModelLoad?(true)
            } catch {
                self.comparisonViewModelError?(error)
            }
        }
    }
    
    private func getBitcoinPrincUsingAPI() {
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
    
    private func loadPredictedPricesFromDatabse() {
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
    
    private func loadPricesFromDatabse() {
        database.loadPricesFromDatabse { result in
            do {
                let newList = try result.get()
                self.priceList = newList
                self.didComparisonViewModelLoad?(true)
            } catch {
                self.comparisonViewModelError?(error)
            }
        }
    }
    
    private func loadReleventAmountOfData() {
        while priceList.count > 7 {
            priceList.removeFirst()
        }
    }
}
