//
//  PredictViewModel.swift
//  BitCoinPredictor
//
//  Created by Vincent Moyo on 2021/07/20.
//

import Foundation

class PredictViewModel {
    
    private var database = DatabaseManager()
    private let bitcoinAPI = BitcoinAPI()
    var priceArray: [PriceArrayModel] = []
    var bitcoinPrice = PriceData()
    var predictedBitcoinPrice = PredictedPriceData()
    var balanceData = BalanceData()
    lazy var intervalValue = 0.0
    var didPredictViewModelLoad: ((Bool) -> Void)?
    var predictViewModelError: ((Error) -> Void)?
    
    func incrementByInterval(_ byteCoinPrice: Double, _ incrementValue: Double, _ increment: Bool) -> Double {
        var finalPrice = 0.0
        if incrementValue > 0 && byteCoinPrice > 0 {
            if increment {
                finalPrice = byteCoinPrice + incrementValue
            } else {
                finalPrice = byteCoinPrice - incrementValue
            }
        }
        return finalPrice
    }
    
    func loadPriceData() {
        bitcoinPrinceUsingAPI()
        loadPricesFromDatabase()
        loadBalancesFromDatabase()
    }
    
    func insertPredictedPriceIntoDatabase(_ delegateSuccess: DisplayingSuccessMessage?, _ delegateError: ErrorReporting) {
        database.updatePredictedPrice(String(predictedBitcoinPrice.currentPrice),
                                                  String(priceArray.count + 5))
        
        subtractBalanceFromPredictedPrice(predictedBitcoinPrice.currentPrice)
        database.delegateSuccess = delegateSuccess
        database.delegateError = delegateError
    }
    
    func subtractBalanceFromPredictedPrice(_ predictedPrice: Double) {
        balanceData.balance -= predictedPrice
        insertIntoBalanceDatabase()
    }
    
    private func insertIntoBalanceDatabase() {
        database.updateAccountBalance(String(balanceData.balance),
                                            String(balanceData.equity),
                                            String(balanceData.freeMargin),
                                            String(checkBitcoin(bitcoinPrice.price, balanceData.balance)))
    }
    
    private func checkBitcoin (_ bitcoinPrice: Double, _ balance: Double) -> Double {
        return round((balance/bitcoinPrice)*100) / 100
    }
    
    func bitcoinPrinceUsingAPI() {
        bitcoinAPI.getAPI { result in
            do {
                let newPrice = try result.get()
                self.bitcoinPrice.price = Double(newPrice)!
                self.didPredictViewModelLoad?(true)
            } catch {
                self.predictViewModelError?(error)
            }
        }
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
                self.didPredictViewModelLoad?(true)
            } catch {
                self.predictViewModelError?(error)
            }
        }
    }
    
    func loadPricesFromDatabase() {
        database.loadPrices { result in
            do {
                let newList = try result.get()
                self.priceArray = newList
                self.didPredictViewModelLoad?(true)
            } catch {
                self.predictViewModelError?(error)
            }
        }
    }
}
